-module(sources@master_of_malt).
-compile(no_auto_import).

-export([endpoint/0, scrape_single/1, new_notes/1, new_card/1]).
-export_type([floki_text_option/0]).

-type floki_text_option() :: deep | js | style | sep.

-spec endpoint() -> binary().
endpoint() ->
    gleam@string:append(<<"https://"/utf8>>, <<"www.masterofmalt.com"/utf8>>).

-spec scrape_single(binary()) -> {ok, models:card()} | {error, binary()}.
scrape_single(Path) ->
    case begin
        _pipe = gleam@http:default_req(),
        _pipe@1 = gleam@http:set_method(_pipe, get),
        _pipe@2 = gleam@http:set_host(_pipe@1, <<"www.masterofmalt.com"/utf8>>),
        _pipe@3 = gleam@http:set_path(_pipe@2, Path),
        _pipe@4 = gleam@httpc:send(_pipe@3),
        gleam@result:replace_error(
            _pipe@4,
            gleam@string:concat(
                [<<"failed to hit url: "/utf8>>,
                 <<"www.masterofmalt.com"/utf8>>,
                 Path]
            )
        )
    end of
        {error, _try} -> {error, _try};
        {ok, Resp} ->
            case erlang:element(2, Resp) of
                200 ->
                    _pipe@5 = erlang:element(4, Resp),
                    _pipe@6 = floki:parse_document(_pipe@5),
                    gleam@result:then(_pipe@6, fun new_card/1);

                Status ->
                    {error,
                     gleam@string:concat(
                         [<<"unexpected status: HTTP "/utf8>>,
                          gleam@int:to_string(Status)]
                     )}
            end
    end.

-spec text(list(floki:html_node())) -> binary().
text(Tree) ->
    'Elixir.Floki':text(Tree, [{deep, gleam@dynamic:from(false)}]).

-spec find_text(list(floki:html_node()), binary()) -> {ok, binary()} |
    {error, binary()}.
find_text(Html, Query) ->
    Text = begin
        _pipe = Html,
        _pipe@1 = floki:find(_pipe, Query),
        _pipe@2 = text(_pipe@1),
        gleam@string:trim(_pipe@2)
    end,
    case Text of
        <<""/utf8>> ->
            {error,
             gleam@string:concat([<<"No text found for query: "/utf8>>, Query])};

        S ->
            {ok, S}
    end.

-spec attribute_from_meta(list(floki:html_node()), binary()) -> {ok, binary()} |
    {error, binary()}.
attribute_from_meta(Html, Property) ->
    _pipe = [<<"[property=\""/utf8>>, Property, <<"\"]"/utf8>>],
    _pipe@1 = gleam@string:concat(_pipe),
    _pipe@2 = floki:find(Html, _pipe@1),
    _pipe@3 = floki:attribute(_pipe@2, <<"content"/utf8>>),
    _pipe@4 = gleam@list:head(_pipe@3),
    gleam@result:replace_error(
        _pipe@4,
        gleam@string:append(
            <<"No data found for meta property: "/utf8>>,
            Property
        )
    ).

-spec new_notes(list(floki:html_node())) -> {ok, models:notes()} |
    {error, binary()}.
new_notes(Html) ->
    case find_text(
        Html,
        <<"#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_noseTastingNote"/utf8>>
    ) of
        {error, _try} -> {error, _try};
        {ok, Nose} ->
            case find_text(
                Html,
                <<"#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_palateTastingNote"/utf8>>
            ) of
                {error, _try@1} -> {error, _try@1};
                {ok, Palate} ->
                    case find_text(
                        Html,
                        <<"#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_finishTastingNote"/utf8>>
                    ) of
                        {error, _try@2} -> {error, _try@2};
                        {ok, Finish} ->
                            Overall = begin
                                _pipe = Html,
                                _pipe@1 = find_text(
                                    _pipe,
                                    <<"#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_overallTastingNote"/utf8>>
                                ),
                                gleam@result:unwrap(_pipe@1, <<""/utf8>>)
                            end,
                            {ok, {notes, Nose, Palate, Finish, Overall}}
                    end
            end
    end.

-spec new_card(list(floki:html_node())) -> {ok, models:card()} |
    {error, binary()}.
new_card(Html) ->
    case attribute_from_meta(Html, <<"og:title"/utf8>>) of
        {error, _try} -> {error, _try};
        {ok, Name} ->
            case attribute_from_meta(Html, <<"og:brand"/utf8>>) of
                {error, _try@1} -> {error, _try@1};
                {ok, Brand} ->
                    case attribute_from_meta(Html, <<"og:image"/utf8>>) of
                        {error, _try@2} -> {error, _try@2};
                        {ok, Img} ->
                            case attribute_from_meta(
                                Html,
                                <<"og:description"/utf8>>
                            ) of
                                {error, _try@3} -> {error, _try@3};
                                {ok, Desc} ->
                                    case new_notes(Html) of
                                        {error, _try@4} -> {error, _try@4};
                                        {ok, Notes} ->
                                            {ok,
                                             {card,
                                              Name,
                                              Brand,
                                              Img,
                                              Desc,
                                              Notes}}
                                    end
                            end
                    end
            end
    end.
