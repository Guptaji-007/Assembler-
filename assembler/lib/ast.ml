(* a instruction *)
type 'a a_instruction =
  | AConstant of int    (*@12*)
  | ASymbol of 'a       (*@label*)

(* c instruction *)
type 'a c_instruction = {
  dest : string option; (* destination *)
  comp : string;       (*computation *)
  jump : string option; (*jump *)
  metadata : 'a option; (* Added metadata option *)
}

(* The overall instruction  *)
type 'a instruction =
  | AInstr of 'a a_instruction
  | CInstr of 'a c_instruction
