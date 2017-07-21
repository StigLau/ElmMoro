module Common.UIFunctions exposing (..)

import Bootstrap.Form.Select as Select
import Html exposing (..)
import Html.Attributes


selectItems: String -> List String -> List (Select.Item msg)
selectItems chosen itemList = List.map (\idz -> Select.item [Html.Attributes.value idz, Html.Attributes.selected (chosen == idz) ] [ text idz]) itemList