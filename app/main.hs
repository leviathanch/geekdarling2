import Prelude              (IO)
import Yesod.Default.Config (fromArgs)
import Yesod.Default.Main   (defaultMainLog)
import Geekdarling.Settings             (parseExtra)
import Geekdarling.Application          (makeApplication)

main :: IO ()
main = defaultMainLog (fromArgs parseExtra) makeApplication
