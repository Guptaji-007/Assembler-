open Assblr.Parser
open Assblr.Machine

(* read lines from terminal input until EOF *)
let terminal_input () =
  let rec aux acc =
    try
      let line = read_line () in
      aux (line :: acc)
    with End_of_file -> List.rev acc
  in
  aux []

(* read lines from the provided file until EOF *)
let file_input filename =
  let channel = open_in filename in
  let rec aux acc =
    try
      let line = input_line channel in
      aux (line :: acc)
    with End_of_file ->
      close_in channel;
      List.rev acc
  in
  aux []

(* assemble machine code *)
let tryto_assemble_inst instr =
  try
    Some (assemble_inst instr)  
  with
  | Failure _ -> None  

(* get machine code from a list of lines *)
let assemble lines =
  let instructions = Parser.parse_assembly lines in
  List.map (fun instr ->
    match instr with
    | Some instr -> (match tryto_assemble_inst instr with
                     | Some mc -> mc  (* Assemble machine code *)
                     | None -> "Error: Could not assemble instruction")  
    | None -> "Error: Invalid instruction format"  (* Handle parsing failure *)
  ) instructions

(* function to read input from file or terminal assemble it and output machine code *)
let () =
  let lines =
    if Array.length Sys.argv > 1 then
      let filename = Sys.argv.(1) in
      file_input filename  (*read file if name is provided*)
    else
      terminal_input ()  (* else read from terminal *)
  in
  let machine_code = assemble lines in
  List.iter print_endline machine_code;
  Printf.printf "Finished assembling %d lines.\n" (List.length lines)
