(*
Copyright (C) 2016- National Institute of Advanced Industrial Science and Technology (AIST)

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*)

let () = Mltop.add_known_plugin (fun () ->
  Feedback.msg_info Pp.(str"codegen 0.1"))
  "codegen"

DECLARE PLUGIN "codegen_plugin"

open Monomorph
open Linear
open Genc

open Stdarg (* for wit_string *)
(*open Constrarg*) (* for wit_global *)

(* for lconstr(...). lconstr accepts "Com 1 + 1" addition to "Com (1 + 1)"
  which is used as Terminate Monomorphization id unit. *)
open Ltac_plugin
open Extraargs

VERNAC COMMAND EXTEND Monomorphization CLASSIFIED AS SIDEFF
    | [ "CodeGen" "Monomorphization" ne_global_list(libref_list) ] ->
      [ monomorphization libref_list ]
    | [ "CodeGen" "Terminate" "Monomorphization" lconstr(term) ] ->
      [ terminate_monomorphization term ]
    | [ "CodeGen" "Linear" lconstr(ty) ] ->
      [ register_linear_type ty ]
    | [ "CodeGen" "LinearCheck" ne_global_list(libref_list) ] ->
      [ linear_type_check_list libref_list ]
    | [ "CodeGen" "LinearTest" constr(t1) constr(t2) ] ->
      [ linear_type_check_test t1 t2 ]
    | [ "CodeGen" "GenC" ne_global_list(libref_list) ] -> [ genc libref_list ]
    | [ "CodeGen" "GenCFile" string(fn) ne_global_list(libref_list) ] ->
      [ genc_file fn libref_list ]
END;;
