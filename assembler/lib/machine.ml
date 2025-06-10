open Ast

(* hashtbl implementation for program variable and label *)

module SymbolTable = struct 
  let table = Hashtbl.create 100
  let variable_counter = ref 16  (* Counter for program variables*)

  let initialize () =
    let predefined_symbols = [
      ("SP", 0); ("LCL", 1); ("ARG", 2); ("THIS", 3); ("THAT", 4);
      ("R0", 0); ("R1", 1); ("R2", 2); ("R3", 3); ("R4", 4); ("R5", 5);
      ("R6", 6); ("R7", 7); ("R8", 8); ("R9", 9); ("R10", 10); ("R11", 11);
      ("R12", 12); ("R13", 13); ("R14", 14); ("R15", 15);
      ("SCREEN", 16384); ("KBD", 24576)
    ] in
    List.iter (fun (symbol, address) -> Hashtbl.add table symbol address) predefined_symbols

  let add_label label address = 
    Hashtbl.add table label address

  let add_variable symbol =
    if not (Hashtbl.mem table symbol) then
      begin
        Hashtbl.add table symbol !variable_counter;
        variable_counter := !variable_counter + 1;
      end;
  Hashtbl.find table symbol  

  let get_address symbol =
    try Hashtbl.find table symbol
    with Not_found -> failwith ("Symbol not found: " ^ symbol)

  let contains_label symbol =
    Hashtbl.mem table symbol
    let contains symbol =
      Hashtbl.mem table symbol
      let contains_variable symbol =
  Hashtbl.mem table symbol

end

(* defined binary for c inst*)

let com_tbl = [
  	("0", "0101010"); ("1", "0111111"); ("-1", "0111010");
  	("D", "0001100"); ("A", "0110000"); ("!D", "0001101");
  	("!A", "0110001"); ("-D", "0001111"); ("-A", "0110011");
  	("D+1", "0011111"); ("A+1", "0110111"); ("D-1", "0001110");
  	("A-1", "0110010"); ("D+A", "0000010"); ("D-A", "0010011");
  	("A-D", "0000111"); ("D&A", "0000000"); ("D|A", "0010101");
  	("M", "1110000"); ("!M", "1110001"); ("-M", "1110011");
  	("M+1", "1110111"); ("M-1", "1110010"); ("D+M", "1000010");
  	("D-M", "1010011"); ("M-D", "1000111"); ("D&M", "1000000");
  	("D|M", "1010101")
]

let des_tbl = [
  	("M", "001"); ("D", "010"); ("MD", "011");
  	("A", "100"); ("AM", "101"); ("AD", "110"); ("AMD", "111")
]

let jmp_tbl = [
  	("JGT", "001"); ("JEQ", "010"); ("JGE", "011");
  	("JLT", "100"); ("JNE", "101"); ("JLE", "110"); ("JMP", "111")
]

module Ainst = struct
  (* Convert an integer to a 15-bit binary string *)
  let int_to_binstr value =
    if value < 0 || value > 32767 then
      failwith "A-instruction value out of bounds";
    let rec aux n acc =
      if n = 0 then acc
      else aux (n / 2) (string_of_int (n mod 2) ^ acc)
    in
    let binary = aux value "" in
    let len = String.length binary in
    let full = String.make (15 - len) '0' ^ binary in  (* Convert the binary to 15 bits *)
    full

  (* Convert an A-instruction to binary *)
  let a_bin = function
    | AConstant value -> "0" ^ (int_to_binstr value)  (* Prepend '0' for A-instruction *)
    | ASymbol symbol -> 
        let address = SymbolTable.get_address symbol in
        "0" ^ (int_to_binstr address)
end


(* Convert C-instruction to binary *)
let c_instr comp dest jump =
  let comp_bits = List.assoc comp com_tbl in
  let dest_bits = match dest with Some d -> List.assoc d des_tbl | None -> "000" in
  let jump_bits = match jump with Some j -> List.assoc j jmp_tbl | None -> "000" in
  Printf.sprintf "111%s%s%s" comp_bits dest_bits jump_bits


let assemble_inst = function
  | AInstr (AConstant value) -> 
      "0" ^ Ainst.int_to_binstr value  (* constant A-inst  *)
  | AInstr (ASymbol symbol) -> 
      let address = 
        if SymbolTable.contains symbol then 
          SymbolTable.get_address symbol  (* Get the address if symbol already exists *)
        else 
          SymbolTable.add_variable symbol  (* Add the variable and return its address *)
      in
      "0" ^ Ainst.int_to_binstr address  (* Convert address to binary *)
  | CInstr {comp; dest; jump; _} -> 
      c_instr comp dest jump  (* Handle C-instruction *)
