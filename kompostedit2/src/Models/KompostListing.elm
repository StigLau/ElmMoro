module Models.KompostListing exposing (DataRepresentation, Row)

type alias DataRepresentation =
  { total_rows: Int
  , offset: Int
  , rows: List Row
  }

type alias Row =
    { id: String
    , key: String
    }