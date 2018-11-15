module Main exposing (main)

import Browser
import Html exposing (Html, br, button, div, text, textarea)
import Html.Attributes exposing (cols, rows, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


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
    = SetInput String
    | RunFormat
    | ReceiveFormattedCode (Result Http.Error String)


runFormat : Model -> Cmd Msg
runFormat model =
    Http.post
        { url = "http://localhost:3000"
        , body = Http.jsonBody <| Encode.object [ ( "code", Encode.string model ) ]
        , expect =
            Http.expectJson
                ReceiveFormattedCode
                (Decode.field "code" Decode.string)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetInput str ->
            ( str, Cmd.none )

        RunFormat ->
            ( model, runFormat model )

        ReceiveFormattedCode result ->
            case result of
                Ok str ->
                    ( str, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick RunFormat ] [ text "Format" ]
        , br [] []
        , textarea [ onInput SetInput, value model, rows 80, cols 80 ] []
        ]
