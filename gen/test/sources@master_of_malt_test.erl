-module(sources@master_of_malt_test).
-compile(no_auto_import).

-export([build_card_test/0, build_notes_test/0]).

-spec build_card_test() -> nil.
build_card_test() ->
    {ok, Html_nodes@1} = case floki:parse_document(
        helpers:card_html_no_overall()
    ) of
        {ok, Html_nodes} -> {ok, Html_nodes};
        _try ->
            erlang:error(#{gleam_error => assert,
                           message => <<"Assertion pattern match failed"/utf8>>,
                           value => _try,
                           module => <<"sources/master_of_malt_test"/utf8>>,
                           function => <<"build_card_test"/utf8>>,
                           line => 8})
    end,
    _pipe = Html_nodes@1,
    _pipe@1 = sources@master_of_malt:new_card(_pipe),
    gleam@should:equal(_pipe@1, {ok, helpers:card_no_overall()}),
    {ok, Html_nodes@3} = case floki:parse_document(
        helpers:card_html_with_overall()
    ) of
        {ok, Html_nodes@2} -> {ok, Html_nodes@2};
        _try@1 ->
            erlang:error(#{gleam_error => assert,
                           message => <<"Assertion pattern match failed"/utf8>>,
                           value => _try@1,
                           module => <<"sources/master_of_malt_test"/utf8>>,
                           function => <<"build_card_test"/utf8>>,
                           line => 14})
    end,
    _pipe@2 = Html_nodes@3,
    _pipe@3 = sources@master_of_malt:new_card(_pipe@2),
    gleam@should:equal(_pipe@3, {ok, helpers:card()}).

-spec build_notes_test() -> nil.
build_notes_test() ->
    {ok, Html_nodes@1} = case floki:parse_document(
        helpers:notes_html_no_overall()
    ) of
        {ok, Html_nodes} -> {ok, Html_nodes};
        _try ->
            erlang:error(#{gleam_error => assert,
                           message => <<"Assertion pattern match failed"/utf8>>,
                           value => _try,
                           module => <<"sources/master_of_malt_test"/utf8>>,
                           function => <<"build_notes_test"/utf8>>,
                           line => 22})
    end,
    _pipe = Html_nodes@1,
    _pipe@1 = sources@master_of_malt:new_notes(_pipe),
    gleam@should:equal(_pipe@1, {ok, helpers:notes_no_overall()}),
    {ok, Html_nodes@3} = case floki:parse_document(
        helpers:notes_html_with_overall()
    ) of
        {ok, Html_nodes@2} -> {ok, Html_nodes@2};
        _try@1 ->
            erlang:error(#{gleam_error => assert,
                           message => <<"Assertion pattern match failed"/utf8>>,
                           value => _try@1,
                           module => <<"sources/master_of_malt_test"/utf8>>,
                           function => <<"build_notes_test"/utf8>>,
                           line => 27})
    end,
    _pipe@2 = Html_nodes@3,
    _pipe@3 = sources@master_of_malt:new_notes(_pipe@2),
    gleam@should:equal(_pipe@3, {ok, helpers:notes_with_overall()}).
