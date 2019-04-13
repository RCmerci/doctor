let test_suites : unit Alcotest.test list =
  [ ( "parser"
    , Var_log_message_parser_test.tests @ Df_parser_test.tests
      @ Sar_load_parser_test.tests )
  ; ("dumper", Var_log_message_dumper_test.tests) ]

let _ = Alcotest.run "proj" test_suites
