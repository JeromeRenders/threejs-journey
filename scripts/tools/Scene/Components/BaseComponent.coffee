# =============================================================================
# > SCENE - COMPONENTS: BASE COMPONENT
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"


export default class

    constructor: (@options) ->



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->


    # ==================================================
    # > UTILS
    # ==================================================
    updateCameraPosition: (pos) ->
        gsap.to(@options.camera.position, {
            x: pos.x,
            y: pos.y,
            z: pos.z,
            duration: 0.4,
            onComplete: => @options.debug.refresh()
        })


    # ==================================================
    # > EVENTS (SHADOW)
    # ==================================================
    _onScroll: (e) ->
        @onScroll(e)

    _onResize: (e) ->
        @onResize(e)

    _onMouseMove: (e) ->
        @onMouseMove(e)

    _onUpdate: (elapsedTime) ->
        @onUpdate(elapsedTime)


    # ==================================================
    # > LOAD / UNLOAD
    # ==================================================
    load: ->
        @init()

    unload: ->
        @options.scene.remove(@mesh)


    # ==================================================
    # > EVENTS
    # ==================================================
    onScroll: (e) ->
    onResize: (e) ->
    onMouseMove: (e) ->
    onUpdate: (elapsedTime) ->



