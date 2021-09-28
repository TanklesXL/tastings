-module(models).
-compile(no_auto_import).

-export_type([card/0, notes/0]).

-type card() :: {card, binary(), binary(), binary(), binary(), notes()}.

-type notes() :: {notes, binary(), binary(), binary(), binary()}.


