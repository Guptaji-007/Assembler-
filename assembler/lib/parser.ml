open Ast
open Machine

module Parser = struct
  (* Remove comments and whitespace from a line *)
  let rmspace line =
    let line = String.trim line in
    match String.index_opt line '/' with
    | Some pos -> String.trim (String.sub line 0 pos)  (* Make substr until the '/' then trim *)
    | None -> line 

  (* Parse an A-instruction *)
  let parse_a_instr line =
    let symbol = String.sub line 1 (String.length line - 1) in
    try
      let value = int_of_string symbol in
      (* Instruction.At (AConstant value)  For constant A-instruction *)
    with Failure _ ->
      Instruction.At (ASymbol symbol)  (* Symbolic reference *)

  (* Parse a C-instruction *)
  let parse_c_instr line =
    let dest, comp_jmp =
      match String.index_opt line '=' with
      | Some _ ->
          let parts = String.split_on_char '=' line in
          (Some (List.nth parts 0), List.nth parts 1)
      | None -> (None, line)
    in
    let comp, jump =
      match String.index_opt comp_jmp ';' with
      | Some _ ->
          let parts = String.split_on_char ';' comp_jmp in
          (List.nth parts 0, Some (List.nth parts 1))
      | None -> (comp_jmp, None)
    in

    let output = match comp with
      | "0" -> Constant Zero
      | "1" -> Constant One
      | "-1" -> Constant MinusOne
      | _ when String.starts_with ~prefix:"-" comp -> uminus Reg.D
      | _ -> add Reg.D  (* Adjust based on your needs; add more cases as necessary *)
    in
    let jump_option = match jump with
      | Some j -> Some (match j with
          | "JGT" -> JGT
          | "JEQ" -> JEQ
          | "JGE" -> JGE
          | "JLT" -> JLT
          | "JNE" -> JNE
          | "JLE" -> JLE
          | "JMP" -> JMP
          | _ -> failwith "Unknown jump"
        )
      | None -> None
    in

    Instruction.C (Option.to_list dest, output, jump_option)  (* Return C-instruction *)

  (* Parse a single line of assembly code *)
  let parse_line line =
    let line = rmspace line in
    match line with
    | "" -> None  
    | _ when String.get line 0 = '@' -> Some (parse_a_instr line) 
    | _ -> Some (parse_c_instr line)

  (* First pass to identify labels and add them to the symbol table *)
  let rec first_pass lines line_num =
    match lines with
    | [] -> []
    | line :: rest ->
        let line = rmspace line in
        match line with
        | "" -> first_pass rest line_num
        | _ when String.get line 0 = '(' ->
            let label = String.sub line 1 (String.length line - 2) in
            SymbolTable.add_label label line_num;  (* Add label separately *)
            first_pass rest line_num
        | _ -> line :: first_pass rest (line_num + 1)

  let rec second_pass lines =
    match lines with
    | [] -> []
    | line :: rest ->
        match parse_line line with
        | Some instr -> instr :: second_pass rest
        | None -> second_pass rest

  (* Function to parse the entire assembly file *)
  let parse_assembly lines =	
    SymbolTable.initialize ();
    let filtered_lines = first_pass lines 0 in   (* For labels *)
    second_pass filtered_lines 
end
