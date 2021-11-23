# =============================================================================
# > SCENE - COMPONENTS: AXES HELPER
# > https://threejs.org/docs/#api/en/helpers/AxesHelper
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        super()

        @axesHelper = new THREE.AxesHelper(1000)
        @axesHelper.visible = false
        @options.scene.add(@axesHelper)

        if @options.debug then @debug()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "Axes helpers", expanded: false })

        @debugFolder.addButton({ title: "Toggle" }).on("click", (e) =>
            @axesHelper.visible = if @axesHelper.visible then false else true
        )

        @options.debug.addSeparator()