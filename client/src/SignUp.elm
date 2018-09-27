module Name exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode exposing (..)
import Url.Builder as Url


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { name : String
    , password : String
    , email : String
    }


type Msg
    = Name String
    | Password String
    | Email String
    | SignUp
    | SignUpValues (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Name name ->
            ( { model | name = name }
            , Cmd.none
            )

        Password password ->
            ( { model | password = password }, Cmd.none )

        Email email ->
            ( { model | email = email }, Cmd.none )

        SignUp ->
            ( model
            , signUp model
            )

        SignUpValues result ->
            case result of
                Ok payload ->
                    ( { model | name = payload }, Cmd.none )

                Err payload ->
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "auth-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                    [ h1 [ class "text-xs-center" ]
                        [ text "Sign up" ]
                    , p [ class "text-xs-center" ]
                        [ a [ href "" ]
                            [ text "Have an account?" ]
                        ]
                    , ul [ class "error-messages" ]
                        [ li []
                            [ text "That email is already taken" ]
                        ]
                    , Html.form []
                        [ viewInput "text" "Your name" model.name Name
                        , viewInput "text" "Email" model.email Email
                        , viewInput "password" "Password" model.password Password
                        , button [ class "btn btn-lg btn-primary pull-xs-right", onClick SignUp, type_ "button" ]
                            [ text "Sign up" ]
                        ]
                    ]
                ]
            ]
        ]
        |> withStyle


withStyle html =
    div []
        [ node "style"
            [ type_ "text/css" ]
            [ text "@import url(https://demo.productionready.io/main.css)" ]
        , html
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    fieldset [ class "form-group" ]
        [ input [ class "form-control form-control-lg", type_ t, placeholder p, value v, onInput toMsg ]
            []
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


signUp : Model -> Cmd Msg
signUp model =
    let
        body =
            model
                |> signUpEncoder
                |> Http.jsonBody
    in
    Http.send SignUpValues
        (Http.post toSignUpUrl
            (model
                |> signUpEncoder
                |> Http.jsonBody
            )
            signUpDecoder
        )


toSignUpUrl : String
toSignUpUrl =
    Url.crossOrigin "https://conduit.productionready.io"
        [ "api", "users" ]
        []


signUpEncoder : Model -> Encode.Value
signUpEncoder model =
    Encode.object
        [ ( "user"
          , Encode.object
                [ ( "username", Encode.string model.name )
                , ( "password", Encode.string model.password )
                , ( "email", Encode.string model.email )
                ]
          )
        ]


signUpDecoder : Decode.Decoder String
signUpDecoder =
    Decode.field "name" Decode.string


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "" "", Cmd.none )
