module Navigation.Page exposing (..)

type Page
    = AuthUI -- Note different cross cutting concerns for login!
    | ListingsUI
    | KompostUI
    | KompositionJsonUI
    | SegmentUI
    | DvlSpecificsUI
    | MediaFileUI
    | NotFound