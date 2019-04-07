let test_suites : unit Alcotest.test list =
  [ ("parser", Var_log_message_parser_test.tests)
  ; ("dumper", Var_log_message_dumper_test.tests) ]

let () = Alcotest.run "proj" test_suites
