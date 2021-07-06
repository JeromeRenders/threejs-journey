# =============================================================================
# > SCENE - COMPONENTS: DODECAHEDRON
# =============================================================================

import * as THREE    from "three"

import DomController from "../DomController.coffee"
import Item          from "./Item.coffee"



# ==================================================
# > CLASS
# ==================================================
export default class extends DomController


    # ==================================================
    # > RENDER
    # ==================================================
    beforeRender: ->

        @instancesID  = "example"
        @instancesModel = Item

        @config = {
            progress: 0
        }


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        # folder = @options.debug.addFolder("Example")




