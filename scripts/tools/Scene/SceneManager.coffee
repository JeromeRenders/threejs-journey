import * as THREE         from "three"
import TrackballControls  from "three-trackballcontrols"
import * as Stats         from "stats.js"
import Tweakpane          from "tweakpane"

import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer.js'
import { RenderPass }     from 'three/examples/jsm/postprocessing/RenderPass.js'
import { GlitchPass }     from 'three/examples/jsm/postprocessing/GlitchPass.js'

import AxesHelper         from "./Components/AxesHelper.coffee"
import Cube               from "./Components/Cube.coffee"
import ExampleController  from "./Components/Dom/Example/Controller.coffee"


export default class

    constructor: (@options) ->

        @clock      = new THREE.Clock()

        @scene      = @createScene()
        @camera     = @createCamera()
        @renderer   = @createRenderer()

        @debug      = @createDebug()
        @stats      = @createStats()
        @controls   = @createControls()
        @composer   = @createComposer()
        @loaders    = @createLoaders()

        @components = @createComponents()

        @options.scroller.on("scroll", (e)       => @onScroll(e) )
        window.addEventListener("resize", (e)    => @onResize(e) )
        window.addEventListener("mousemove", (e) => @onMouseMove(e) )

        @onUpdate()

        console.log @


    # ==================================================
    # > THREE COMPONENTS
    # ==================================================
    createScene: ->
        scene = new THREE.Scene()

        return scene

    createCamera: ->
        fieldOfView = 75
        aspectRatio = @getViewport().aspectRatio
        nearPlane   = 0.1
        farPlane    = 100

        camera = new THREE.PerspectiveCamera(fieldOfView, aspectRatio, nearPlane, farPlane)
        camera.position.set(0, 0, 10)
        camera.lookAt new THREE.Vector3(0, 0, 0)

        return camera

    createRenderer: ->
        renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
        renderer.setSize @getViewport().width, @getViewport().height
        renderer.setPixelRatio = Math.min window.devicePixelRatio, 2

        @options.container.appendChild(renderer.domElement)

        renderer.domElement.style.position      = "fixed"
        renderer.domElement.style.top           = "0px"
        renderer.domElement.style.left          = "0px"
        # renderer.domElement.style.zIndex        = "1111"
        # renderer.domElement.style.pointerEvents = "none"

        return renderer

    createComponents: ->
        options = {
            debug:     @debug
            loaders:   @loaders
            scene:     @scene
            camera:    @camera
            renderer:  @renderer
        }

        components = {
            # axesHelper: new AxesHelper(options)
            cube:       new Cube(options)
            # example:    new ExampleController(options)
        }

        return components


    # ==================================================
    # > THREE UTILS
    # ==================================================
    createControls: ->
        unless @options.controls then return false

        controls = new TrackballControls(@camera, @renderer.domElement)
        controls.noZoom = false

        return controls

    createDebug: ->
        unless @options.debug then return false

        debug = new Tweakpane({
            title: "CONTROLS"
            expanded: false
        })
        debug.addSeparator()

        return debug

    createStats: ->
        unless @options.stats then return false

        stats = new Stats()

        @options.container.appendChild(stats.dom)

        return stats

    createComposer: ->
        unless @options.composer then return false

        # composer = new EffectComposer(@renderer)

        # renderPass = new RenderPass(@scene, @camera)
        # renderPass.renderToScreen = true
        # composer.addPass(renderPass)

        # Example:
        # glitch = new GlitchPass()
        # composer.addPass(glitch)

        return composer

    createLoaders: ->
        loaders = {}

        loaders["texture"] = new THREE.TextureLoader()

        return loaders


    # ==================================================
    # > UTILS
    # ==================================================
    getViewport: ->
        width       = window.innerWidth
        height      = window.innerHeight
        aspectRatio = width / height

        return { width, height, aspectRatio }


    # ==================================================
    # > EVENTS
    # ==================================================
    onScroll: (e) ->
        for name, c of @components then c._onScroll(e)

    onResize: (e) ->
        for name, c of @components then c._onResize(e)

        @camera.aspect = @getViewport().aspectRatio
        @camera.updateProjectionMatrix()

        @renderer.setSize(@getViewport().width, @getViewport().height)

    onMouseMove: (e) ->
        for name, c of @components then c._onMouseMove(e)

    onUpdate: ->
        elapsedTime = @clock.getElapsedTime()
        for name, c of @components then c._onUpdate(elapsedTime)

        if @controls then @controls.update()
        if @stats    then @stats.update()

        if @composer then @composer.render()
        else @renderer.render(@scene, @camera)

        requestAnimationFrame(() => @onUpdate())



