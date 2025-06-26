module Tests exposing (..)

import Test exposing (..)
import SimpleTests


-- Main test suite for KompostEdit
all : Test
all =
    describe "KompostEdit Application Tests"
        [ SimpleTests.all
        ]