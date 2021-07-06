# =============================================================================
# > SCENE - COMPONENTS: DODECAHEDRON
# =============================================================================

import * as THREE    from "three"


# ==================================================
# > CLASS
# ==================================================
export default class

    constructor: (@el, @options, @config) ->

        @id = @el.dataset.glid

        @beforeRender()

        unless @mesh then return

        @updateBounds()
        @updateSize()
        @updatePosition()

        @afterRender()


    # ==================================================
    # > RENDER
    # ==================================================
    beforeRender: ->

    afterRender: ->


    # ==================================================
    # > UTILS
    # ==================================================
    calculateUnitSize: (distance = @options.camera.position.z) ->
        vFov   = @options.camera.fov * Math.PI / 180
        height = 2 * Math.tan(vFov / 2) * distance
        width  = height * @options.camera.aspect

        return { width, height }

    getAspectRatio: (imageAspect = 1) ->
        aspectRatio = { w: @el.offsetWidth, h: @el.offsetHeight, a1: 1, a2: 1 }

        if @el.offsetHeight / @el.offsetWidth < imageAspect
            aspectRatio.a1 = 1
            aspectRatio.a2 = @el.offsetHeight / @el.offsetWidth / imageAspect
        else
            aspectRatio.a1 = (@el.offsetWidth / @el.offsetHeight) * imageAspect
            aspectRatio.a2 = 1

        return aspectRatio

    clamp: (value, min = 0, max = 1) ->
        return Math.min(Math.max(value, min), max)

    rand: (min = 0, max = 1) ->
        return min + (max - min) * Math.random()


    # ==================================================
    # > OBJECT UPDATE
    # ==================================================
    updateBounds: ->
        rect = @el.getBoundingClientRect()

        @bounds = {
            left:   rect.left
            top:    rect.top
            bottom: rect.bottom
            width:  rect.width
            height: rect.height
        }

        # margin = 100
        # @inViewport = if @bounds.top + @bounds.height + margin >= 0 && @bounds.bottom - @bounds.height - margin <= window.innerHeight then true else false

    updateSize: ->
        @camUnit = @calculateUnitSize(@options.camera.position.z - @mesh.position.z)

        x = @bounds.width / window.innerWidth
        y = @bounds.height / window.innerHeight

        if !x || !y then return

        @mesh.scale.x = @camUnit.width * x
        @mesh.scale.y = @camUnit.height * y

    updatePosition: ->
        unless @mesh then return

        # Set origin to top left
        @mesh.position.x = -(@camUnit.width / 2) + (@mesh.scale.x / 2)
        @mesh.position.y = (@camUnit.height / 2) - (@mesh.scale.y / 2)

        # Set position
        @mesh.position.x += (@bounds.left / window.innerWidth) * @camUnit.width
        @mesh.position.y -= (@bounds.top / window.innerHeight) * @camUnit.height


    # ==================================================
    # > SHADOW EVENTS
    # ==================================================
    _onScroll: (e) ->
        unless @mesh then return

        @updateBounds()
        @updateSize()
        @updatePosition()

        @onScroll(e)

    _onResize: (e) ->
        unless @mesh then return

        @updateBounds()
        @updateSize()
        @updatePosition()

        @onResize(e)

    _onUpdate: ->
        unless @mesh then return

        @onUpdate()

    _onMouseMove: (e) ->
        unless @mesh then return

        @onMouseMove(e)

    _onMouseEnter: ->
        unless @mesh then return

        @onMouseEnter()

    _onMouseLeave: ->
        unless @mesh then return

        @onMouseLeave()


    # ==================================================
    # > EVENTS
    # ==================================================
    onScroll: (e, isScrolling) ->
    onScrollEnd: ->
    onResize: (e) ->
    onUpdate: ->
    onMouseMove: (e) ->
    onMouseEnter: ->
    onMouseLeave: ->

