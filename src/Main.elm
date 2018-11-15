module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (cols, rows, value)
import Html.Events exposing (onClick)


main : Platform.Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    String


init : Model
init =
    """module Dom.Components.Header       exposing (Navigation, view)
type alias Navigation = { previous :
 String, next : String }
"""



-- UPDATE


type Msg
    = RunFormat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RunFormat ->
            ( model, Cmd.none )



-- VIEW
-- <button id="format-button" type="button"> Format </button>
-- <br/>
-- <textarea id="content" name="content" rows="80" cols="80"></textarea>


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick RunFormat ] [ text "Format" ]
        , textarea [ value model, rows 80, cols 80 ] []
        ]
