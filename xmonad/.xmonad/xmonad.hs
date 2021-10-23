-- Plik konfiguracyjny dla menadzera okien XMonad od Szymzala
-- Prosze o nie edytowanie tego pliku chyba, ze wiesz co robisz

-- ---------------------- --
-- Importowanie bibliotek --
-- ---------------------- --
-- Podstawy
import XMonad
import XMonad.Config.Desktop
import System.IO (hPutStrLn)
import qualified XMonad.StackSet as W

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName

-- Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing (spacingRaw, Border(Border))
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.ResizableTile
import XMonad.Layout.Named (named)

-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)

-- ------------ --
-- Konfiguracja --
-- ------------ --

myModMask = mod4Mask -- The Windows key
myTerminal = "alacritty"
mySpacing = spacingRaw False (Border 10 10 10 10) True (Border 5 5 5 5) True
myBorderWidth = 2
myNormalBorderColor = "#839496"
myFocusedBorderColor = "#268BD2"
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- ------------ --
-- Startup Hook --
-- ------------ --

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom --config ${HOME}/.config/picom/picom.conf &"
    setWMName "LG3D"

-- ------ --
-- Layout --
-- ------ --

myLayout = avoidStruts ( grid ||| tiled ||| full ||| monocle ) ||| fullscreen
    where
        tiled = named "Stack" $ mySpacing $ ResizableTall 1 (3/100) (1/2) []
        grid = named "Grid" $ mySpacing $ Grid (16/10)
        full = named "Grid Full" $ Grid (16/10)
        monocle = named "Full" $ smartBorders (Full)
        fullscreen = named "Fullscreen" $ noBorders (Full)
        nmaster = 1
        ratio = 1/2 
        delta = 3/100

-- -------------------------- --
-- Window rules (Manage Hook) --
-- -------------------------- --

myManageHook = composeAll
    [ className =? "confim" --> doFloat
    , className =? "file_progress" --> doFloat
    , className =? "dialog" --> doFloat
    , className =? "download" --> doFloat
    , className =? "error" --> doFloat
    , className =? "notification" --> doFloat
    , isFullscreen --> doFullFloat
    ]

-- ------------ --
-- Key bindings --
-- ------------ --

myKeys = []

-- ---- --
-- Main --
-- ---- --

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 ${HOME}/.config/xmobar/xmobarrc"
    xmproc1 <- spawnPipe "xmobar -x 1 ${HOME}/.config/xmobar/xmobarrc"
    xmonad $ ewmh desktopConfig
        { manageHook = manageDocks <+> manageHook desktopConfig
        , startupHook = myStartupHook
        , layoutHook = myLayout
        , borderWidth = myBorderWidth
        , terminal = myTerminal
        , modMask = myModMask
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
                        , ppCurrent = xmobarColor "#c792ea" "" . wrap "<box type=Bottom width=2 mb=2 color=#c792ea>" "</box>"
                        , ppVisible = xmobarColor "#c792ea" ""
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "<box type=Top width=2 mt=2 color=#82AAFF>" "</box>"
                        , ppHiddenNoWindows = xmobarColor "#82AAFF" ""
                        , ppTitle = xmobarColor "#b3afc2" "" . shorten 60
                        , ppSep = "<fc=#666666> | </fc>"
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"
                        , ppExtras = [windowCount]
                        , ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
                    } `additionalKeysP` myKeys
