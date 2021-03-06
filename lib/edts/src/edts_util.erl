%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc utility library for edts.
%%% @end
%%% @author Thomas Järvstrand <tjarvstrand@gmail.com>
%%% @copyright
%%% Copyright 2013 Thomas Järvstrand <tjarvstrand@gmail.com>
%%%
%%% This file is part of EDTS.
%%%
%%% EDTS is free software: you can redistribute it and/or modify
%%% it under the terms of the GNU Lesser General Public License as published by
%%% the Free Software Foundation, either version 3 of the License, or
%%% (at your option) any later version.
%%%
%%% EDTS is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%% GNU Lesser General Public License for more details.
%%%
%%% You should have received a copy of the GNU Lesser General Public License
%%% along with EDTS. If not, see <http://www.gnu.org/licenses/>.
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%_* Module declaration =======================================================
-module(edts_util).

%%%_* Includes =================================================================
-include_lib("eunit/include/eunit.hrl").

%%%_* Exports ==================================================================

-export([shorten_path/1]).

%%%_* Defines ==================================================================

%%%_* Types ====================================================================

%%%_* API ======================================================================

shorten_path("") -> "";
shorten_path(P)  ->
  case shorten_path(filename:split(P), []) of
    [Component] -> Component;
    Components  -> filename:join(Components)
  end.

shorten_path([],           [])         -> ["."];
shorten_path([],           Acc)        -> lists:reverse(Acc);
shorten_path(["."|T],      Acc)        -> shorten_path(T, Acc);
shorten_path([".."|T],     [])         -> shorten_path(T, [".."]);
shorten_path([".."|T], [".."|_] = Acc) -> shorten_path(T, [".."|Acc]);
shorten_path([".."|T],     Acc)        -> shorten_path(T, tl(Acc));
shorten_path([H|T],        Acc)        -> shorten_path(T, [H|Acc]).



%%%_* Internal functions =======================================================


%%%_* Unit tests ===============================================================

shorten_path_test_() ->
  [ ?_assertEqual("", shorten_path("")),
    ?_assertEqual(".", shorten_path(".")),
    ?_assertEqual("..", shorten_path("..")),
    ?_assertEqual("../..", shorten_path("../..")),
    ?_assertEqual("../ebin", shorten_path("../ebin")),
    ?_assertEqual("..", shorten_path("../ebin/..")),
    ?_assertEqual("..", shorten_path("../ebin/./.."))
  ].

%%%_* Test helpers =============================================================

%%%_* Emacs ====================================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:

