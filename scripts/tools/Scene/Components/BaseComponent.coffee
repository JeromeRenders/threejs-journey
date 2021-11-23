# =============================================================================
# > SCENE - COMPONENTS: BASE COMPONENT
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"


export default class

    constructor: (@options) ->
        @title = "Choose an experience"


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
            duration: 0,
            onComplete: =>
                @options.debug.refresh()
                @options.camera.lookAt new THREE.Vector3(0, 0, 0)
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
        @unload()
        @init()

        document.querySelector(".home__scene__title").innerHTML = @title

    unload: ->
        @options.scene.remove(@mesh)

        document.querySelector(".home__scene__title").innerHTML = "Choose an experience"


    # ==================================================
    # > EVENTS
    # ==================================================
    onScroll: (e) ->
    onResize: (e) ->
    onMouseMove: (e) ->
    onUpdate: (elapsedTime) ->



