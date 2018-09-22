module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    }


init : Model
init =
    Model "hello"



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model



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
                            [ a [ class "tag-pill tag-default", href "" ]
                                [ text "programming" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "javascript" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "emberjs" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "angularjs" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "react" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "mean" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "node" ]
                            , a [ class "tag-pill tag-default", href "" ]
                                [ text "rails" ]
                            ]
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
