module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Platform.Cmd
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


type alias Article =
    { title : String
    , slug : String
    , body : String
    , createdAt : String
    , updatedAt : String
    , tagList : List String
    , description : String
    , author : ArticleAuthor
    , favorited : Bool
    , favoritesCount : Int
    }


type alias ArticleAuthor =
    { username : String
    , bio : Maybe Bool
    , image : String
    , following : Bool
    }


type alias Articles =
    { articles : List Article
    , articleCount : Int
    }


type alias Model =
    { articles : Articles
    , limit : Int
    , page : Int
    , tags : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Articles [] 0) 10 0 [], Platform.Cmd.batch [ getTags, getArticles 10 0 ] )



-- UPDATE


type Msg
    = GetTags
    | NewTags (Result Http.Error (List String))
    | GetArticles
    | NewArticles (Result Http.Error Articles)
    | ChangePage Int


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

        GetArticles ->
            ( model
            , getArticles model.limit (model.page * 10)
            )

        NewArticles result ->
            case result of
                Ok newArticles ->
                    ( { model | articles = newArticles }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        ChangePage page ->
            ( { model | page = page }
            , getArticles 10 (page * 10)
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
                    , div []
                        (List.map
                            renderArticle
                            model.articles.articles
                        )
                    , nav [] (List.map (renderPagination model.page) (List.range 0 ((model.articles.articleCount - remainderBy model.articles.articleCount 10) // 10)))
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


renderArticle : Article -> Html Msg
renderArticle article =
    div [ class "article-preview" ]
        [ div [ class "article-meta" ]
            [ a [ href "profile.html" ]
                [ img [ src article.author.image ]
                    []
                ]
            , div [ class "info" ]
                [ a [ class "author", href "" ]
                    [ text article.author.username ]
                , span [ class "date" ]
                    [ text article.createdAt ]
                ]
            , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                [ i [ class "ion-heart" ]
                    []
                , text (String.fromInt article.favoritesCount)
                ]
            ]
        , a [ class "preview-link", href "" ]
            [ h1 []
                [ text article.title ]
            , p []
                [ text article.description ]
            , span []
                [ text "Read more..." ]
            ]
        ]


renderPagination : Int -> Int -> Html Msg
renderPagination currentPage page =
    ul [ class "pagination" ]
        [ li
            [ classList
                [ ( "page-item", True )
                , ( "active", page == currentPage )
                ]
            ]
            [ a
                [ class "page-link"
                , href "#"
                , onClick (ChangePage page)
                ]
                [ text (String.fromInt (page + 1)) ]
            ]
        ]



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


getArticles : Int -> Int -> Cmd Msg
getArticles limit offset =
    Http.send NewArticles (Http.get (toArticlesUrl limit offset) articlesDecoder)


toArticlesUrl : Int -> Int -> String
toArticlesUrl limit offset =
    Url.crossOrigin "https://conduit.productionready.io"
        [ "api", "articles" ]
        [ Url.string "limit" (String.fromInt limit)
        , Url.string "offset" (String.fromInt offset)
        ]


articlesDecoder : Decode.Decoder Articles
articlesDecoder =
    Decode.map2 Articles
        (Decode.field "articles" (Decode.list articleDecoder))
        (Decode.field "articlesCount" Decode.int)


articleDecoder : Decode.Decoder Article
articleDecoder =
    Decode.succeed Article
        |> required "title" Decode.string
        |> required "slug" Decode.string
        |> required "body" Decode.string
        |> required "createdAt" Decode.string
        |> required "updatedAt" Decode.string
        |> required "tagList" (Decode.list Decode.string)
        |> required "description" Decode.string
        |> required "author" articleAuthorDecoder
        |> required "favorited" Decode.bool
        |> required "favoritesCount" Decode.int


articleAuthorDecoder : Decode.Decoder ArticleAuthor
articleAuthorDecoder =
    Decode.map4 ArticleAuthor
        (Decode.field "username" Decode.string)
        (Decode.field "bio" (Decode.maybe Decode.bool))
        (Decode.field "image" Decode.string)
        (Decode.field "following" Decode.bool)
