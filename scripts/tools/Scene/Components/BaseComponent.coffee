# =============================================================================
# > SCENE - COMPONENTS: BASE COMPONENT
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"


export default class

    constructor: (@options) ->
        @title = "THREE.JS JOURNEY"
        @desc  = "Lorem ipsum"


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
                if @options.debug then @options.debug.refresh()
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

        document.querySelector(".home__scene__title").innerHTML  = @title
        document.querySelector(".home__scene__helper").innerHTML = @desc

    unload: ->
        @options.scene.remove(@mesh)
        @options.renderer.setClearColor("#000000")

        document.querySelector(".home__scene__title").innerHTML  = "THREE.JS JOURNEY"
        document.querySelector(".home__scene__helper").innerHTML = "Lorem ipsum"


    # ==================================================
    # > EVENTS
    # ==================================================
    onScroll: (e) ->
    onResize: (e) ->
    onMouseMove: (e) ->
    onUpdate: (elapsedTime) ->



