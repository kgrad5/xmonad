-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import System.IO

main = do
     xmproc <- spawnPipe "/bin/xmobar ~/.xmobarrc"
     spawn "xcompmgr -cCfF &"
     spawn "feh --bg-fill ~/.xmonad/background.jpg"

     session <- getEnv "DESKTOP_SESSION"
     xmonad $ defaultConfig {
	terminal = "urxvt"
	, manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
	, logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
     } `additionalKeys`
	[ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock") 
	]
     xmonad  $ maybe desktopConfig desktop session

desktop "gnome" = gnomeConfig
desktop "kde" = kde4Config
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig
