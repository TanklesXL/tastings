-module(helpers).
-compile(no_auto_import).

-export([notes_html_no_overall/0, notes_html_with_overall/0, card_html_no_overall/0, card_html_with_overall/0, notes_no_overall/0, notes_with_overall/0, card_no_overall/0, card/0]).

-spec meta(binary(), binary()) -> binary().
meta(Property, Content) ->
    gleam@string:concat(
        [<<"<meta content=\""/utf8>>,
         Content,
         <<"\" property=\"og:"/utf8>>,
         Property,
         <<"\"/>"/utf8>>]
    ).

-spec html_metas() -> binary().
html_metas() ->
    gleam@string:concat(
        [meta(
             erlang:element(
                 1,
                 {<<"title"/utf8>>, <<"Ardbeg 10 Year Old"/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"title"/utf8>>, <<"Ardbeg 10 Year Old"/utf8>>}
             )
         ),
         meta(
             erlang:element(1, {<<"brand"/utf8>>, <<"Ardbeg"/utf8>>}),
             erlang:element(2, {<<"brand"/utf8>>, <<"Ardbeg"/utf8>>})
         ),
         meta(
             erlang:element(
                 1,
                 {<<"description"/utf8>>,
                  <<"A phenomenal whisky packing powerful peaty deliciousness, Ardbeg 10 Year Old is a favourite of many whisky lovers around the world.
Produced on the Kildalton Coast of Islay, this single malt matures for a decade before being bottled without any chill-filtration.
If you're after a whisky with full of coastal air, smoke and more, this is exactly what you want."/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"description"/utf8>>,
                  <<"A phenomenal whisky packing powerful peaty deliciousness, Ardbeg 10 Year Old is a favourite of many whisky lovers around the world.
Produced on the Kildalton Coast of Islay, this single malt matures for a decade before being bottled without any chill-filtration.
If you're after a whisky with full of coastal air, smoke and more, this is exactly what you want."/utf8>>}
             )
         ),
         meta(
             erlang:element(
                 1,
                 {<<"image"/utf8>>,
                  <<"https://cdn2.masterofmalt.com/whiskies/p-2813/ardbeg/ardbeg-10-year-old-whisky.jpg?ss=2.0"/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"image"/utf8>>,
                  <<"https://cdn2.masterofmalt.com/whiskies/p-2813/ardbeg/ardbeg-10-year-old-whisky.jpg?ss=2.0"/utf8>>}
             )
         )]
    ).

-spec note_html(binary(), binary()) -> binary().
note_html(Id, Content) ->
    gleam@string:concat(
        [<<"<p id=\""/utf8>>,
         Id,
         <<"\">"/utf8>>,
         <<"<b>XXX:</b>"/utf8>>,
         Content,
         <<"</p>"/utf8>>]
    ).

-spec notes_html_no_overall() -> binary().
notes_html_no_overall() ->
    gleam@string:concat(
        [note_html(
             erlang:element(
                 1,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_noseTastingNote"/utf8>>,
                  <<"A ridge of vanilla leads to mountain of peat capped with citrus fruits and circled by clouds of sea spray."/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_noseTastingNote"/utf8>>,
                  <<"A ridge of vanilla leads to mountain of peat capped with citrus fruits and circled by clouds of sea spray."/utf8>>}
             )
         ),
         note_html(
             erlang:element(
                 1,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_palateTastingNote"/utf8>>,
                  <<"Sweet vanilla counterbalanced with lemon and lime followed by that surging Ardbeg smoke that we all know and love."/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_palateTastingNote"/utf8>>,
                  <<"Sweet vanilla counterbalanced with lemon and lime followed by that surging Ardbeg smoke that we all know and love."/utf8>>}
             )
         ),
         note_html(
             erlang:element(
                 1,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_finishTastingNote"/utf8>>,
                  <<"Long and glorious; sea salted caramel and beach bonfire smoke."/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_finishTastingNote"/utf8>>,
                  <<"Long and glorious; sea salted caramel and beach bonfire smoke."/utf8>>}
             )
         )]
    ).

-spec notes_html_with_overall() -> binary().
notes_html_with_overall() ->
    gleam@string:concat(
        [notes_html_no_overall(),
         note_html(
             erlang:element(
                 1,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_overallTastingNote"/utf8>>,
                  <<"Precise balance, big smoke and non-chill filtered. This is why this is such a famous dram."/utf8>>}
             ),
             erlang:element(
                 2,
                 {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_overallTastingNote"/utf8>>,
                  <<"Precise balance, big smoke and non-chill filtered. This is why this is such a famous dram."/utf8>>}
             )
         )]
    ).

-spec card_html_no_overall() -> binary().
card_html_no_overall() ->
    gleam@string:concat(
        [html_metas(),
         <<"<div>"/utf8>>,
         notes_html_no_overall(),
         <<"</div>"/utf8>>]
    ).

-spec card_html_with_overall() -> binary().
card_html_with_overall() ->
    gleam@string:concat(
        [html_metas(),
         <<"<div>"/utf8>>,
         notes_html_with_overall(),
         <<"</div>"/utf8>>]
    ).

-spec notes_no_overall() -> models:notes().
notes_no_overall() ->
    {notes,
     erlang:element(
         2,
         {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_noseTastingNote"/utf8>>,
          <<"A ridge of vanilla leads to mountain of peat capped with citrus fruits and circled by clouds of sea spray."/utf8>>}
     ),
     erlang:element(
         2,
         {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_palateTastingNote"/utf8>>,
          <<"Sweet vanilla counterbalanced with lemon and lime followed by that surging Ardbeg smoke that we all know and love."/utf8>>}
     ),
     erlang:element(
         2,
         {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_finishTastingNote"/utf8>>,
          <<"Long and glorious; sea salted caramel and beach bonfire smoke."/utf8>>}
     ),
     <<""/utf8>>}.

-spec notes_with_overall() -> models:notes().
notes_with_overall() ->
    Notes = notes_no_overall(),
    erlang:setelement(
        5,
        Notes,
        erlang:element(
            2,
            {<<"ContentPlaceHolder1_ctl00_ctl03_TastingNoteBox_ctl00_overallTastingNote"/utf8>>,
             <<"Precise balance, big smoke and non-chill filtered. This is why this is such a famous dram."/utf8>>}
        )
    ).

-spec card_no_overall() -> models:card().
card_no_overall() ->
    {card,
     erlang:element(2, {<<"title"/utf8>>, <<"Ardbeg 10 Year Old"/utf8>>}),
     erlang:element(2, {<<"brand"/utf8>>, <<"Ardbeg"/utf8>>}),
     erlang:element(
         2,
         {<<"image"/utf8>>,
          <<"https://cdn2.masterofmalt.com/whiskies/p-2813/ardbeg/ardbeg-10-year-old-whisky.jpg?ss=2.0"/utf8>>}
     ),
     erlang:element(
         2,
         {<<"description"/utf8>>,
          <<"A phenomenal whisky packing powerful peaty deliciousness, Ardbeg 10 Year Old is a favourite of many whisky lovers around the world.
Produced on the Kildalton Coast of Islay, this single malt matures for a decade before being bottled without any chill-filtration.
If you're after a whisky with full of coastal air, smoke and more, this is exactly what you want."/utf8>>}
     ),
     notes_no_overall()}.

-spec card() -> models:card().
card() ->
    {card,
     erlang:element(2, {<<"title"/utf8>>, <<"Ardbeg 10 Year Old"/utf8>>}),
     erlang:element(2, {<<"brand"/utf8>>, <<"Ardbeg"/utf8>>}),
     erlang:element(
         2,
         {<<"image"/utf8>>,
          <<"https://cdn2.masterofmalt.com/whiskies/p-2813/ardbeg/ardbeg-10-year-old-whisky.jpg?ss=2.0"/utf8>>}
     ),
     erlang:element(
         2,
         {<<"description"/utf8>>,
          <<"A phenomenal whisky packing powerful peaty deliciousness, Ardbeg 10 Year Old is a favourite of many whisky lovers around the world.
Produced on the Kildalton Coast of Islay, this single malt matures for a decade before being bottled without any chill-filtration.
If you're after a whisky with full of coastal air, smoke and more, this is exactly what you want."/utf8>>}
     ),
     notes_with_overall()}.
