module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Url.Builder as Url



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { tags : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [], getTags )



-- UPDATE


type Msg
    = GetTags
    | NewTags (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetTags ->
            ( model
            , getTags
            )

        NewTags result ->
            case result of
                Ok newTags ->
                    ( { model | tags = newTags }, Cmd.none )

                Err _ ->
                    ( model
                    , Cmd.none
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ div [ class "banner" ]
            [ div [ class "container" ]
                [ h1 [ class "logo-font" ]
                    [ text "conduit" ]
                , p []
                    [ text "A place to share your knowledge." ]
                ]
            ]
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-9" ]
                    [ div [ class "feed-toggle" ]
                        [ ul [ class "nav nav-pills outline-active" ]
                            [ li [ class "nav-item" ]
                                [ a [ class "nav-link disabled", href "" ]
                                    [ text "Your Feed" ]
                                ]
                            , li [ class "nav-item" ]
                                [ a [ class "nav-link active", href "" ]
                                    [ text "Global Feed" ]
                                ]
                            ]
                        ]
                    , div [ class "article-preview" ]
                        [ div [ class "article-meta" ]
                            [ a [ href "profile.html" ]
                                [ img [ src "http://i.imgur.com/Qr71crq.jpg" ]
                                    []
                                ]
                            , div [ class "info" ]
                                [ a [ class "author", href "" ]
                                    [ text "Eric Simons" ]
                                , span [ class "date" ]
                                    [ text "January 20th" ]
                                ]
                            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                                [ i [ class "ion-heart" ]
                                    []
                                , text "29            "
                                ]
                            ]
                        , a [ class "preview-link", href "" ]
                            [ h1 []
                                [ text "How to build webapps that scale" ]
                            , p []
                                [ text "This is the description for the post." ]
                            , span []
                                [ text "Read more..." ]
                            ]
                        ]
                    , div [ class "article-preview" ]
                        [ div [ class "article-meta" ]
                            [ a [ href "profile.html" ]
                                [ img [ src "http://i.imgur.com/N4VcUeJ.jpg" ]
                                    []
                                ]
                            , div [ class "info" ]
                                [ a [ class "author", href "" ]
                                    [ text "Albert Pai" ]
                                , span [ class "date" ]
                                    [ text "January 20th" ]
                                ]
                            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                                [ i [ class "ion-heart" ]
                                    []
                                , text "32            "
                                ]
                            ]
                        , a [ class "preview-link", href "" ]
                            [ h1 []
                                [ text "The song you won't ever stop singing. No matter how hard you try." ]
                            , p []
                                [ text "This is the description for the post." ]
                            , span []
                                [ text "Read more..." ]
                            ]
                        ]
                    ]
                , div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ p []
                            [ text "Popular Tags" ]
                        , div [ class "tag-list" ]
                            (List.map
                                renderTag
                                model.tags
                            )
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


renderTag : String -> Html Msg
renderTag tag =
    a [ class "tag-pill tag-default", href "" ]
        [ text tag ]



-- HTTP


getTags : Cmd Msg
getTags =
    Http.send NewTags (Http.get toTagsUrl tagsDecoder)


toTagsUrl : String
toTagsUrl =
    Url.crossOrigin "https://conduit.productionready.io"
        [ "api", "tags" ]
        []


tagsDecoder : Decode.Decoder (List String)
tagsDecoder =
    Decode.field "tags" (Decode.list Decode.string)
