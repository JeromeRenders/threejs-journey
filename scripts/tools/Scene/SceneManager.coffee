import * as THREE         from "three"
import TrackballControls  from "three-trackballcontrols"
import * as Stats         from "stats.js"
import { Pane }           from "tweakpane"
import { GLTFLoader }     from "three/examples/jsm/loaders/GLTFLoader.js"
import { DRACOLoader }    from "three/examples/jsm/loaders/DRACOLoader.js"

import { EffectComposer } from "three/examples/jsm/postprocessing/EffectComposer.js"
import { RenderPass }     from "three/examples/jsm/postprocessing/RenderPass.js"
import { GlitchPass }     from "three/examples/jsm/postprocessing/GlitchPass.js"

import AxesHelper         from "./Components/AxesHelper.coffee"
import Lights             from "./Components/Lights.coffee"
import Door               from "./Components/Door.coffee"
import Font               from "./Components/Font.coffee"
import Shadows            from "./Components/Shadows.coffee"
import HauntedHouse       from "./Components/HauntedHouse.coffee"
import Particles          from "./Components/Particles.coffee"
import Galaxy             from "./Components/Galaxy.coffee"
import Raycaster          from "./Components/Raycaster.coffee"
import Physics            from "./Components/Physics.coffee"
import ImportedModels     from "./Components/ImportedModels.coffee"
import Shaders            from "./Components/Shaders.coffee"
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

        # scene.fog = new THREE.Fog("#262837", 1, 25) # HauntedHouse

        return scene

    createCamera: ->
        fieldOfView = 75
        aspectRatio = @getViewport().aspectRatio
        nearPlane   = 0.1
        farPlane    = 100

        camera = new THREE.PerspectiveCamera(fieldOfView, aspectRatio, nearPlane, farPlane)
        camera.position.set(0, 0, 2) # Default
        # camera.position.set(6.5, 2.6, 6.5) # HauntedHouse
        camera.lookAt new THREE.Vector3(0, 0, 0)

        return camera

    createRenderer: ->
        renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
        renderer.setSize @getViewport().width, @getViewport().height
        renderer.setPixelRatio = Math.min window.devicePixelRatio, 2
        renderer.setClearColor("#000000")
        # renderer.setClearColor("#262837") # HauntedHouse

        # Shadows setup
        renderer.shadowMap.enabled = true
        renderer.shadowMap.type = THREE.PCFSoftShadowMap

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

            # lights:     new Lights(options)
            # door:       new Door(options)
            # font:       new Font(options)
            # shadows:    new Shadows(options)
            # hauntedHouse: new HauntedHouse(options)
            # particles: new Particles(options)
            # galaxy: new Galaxy(options)
            # raycaster: new Raycaster(options)
            # physics: new Physics(options)
            # importedModels: new ImportedModels(options)
            shaders: new Shaders(options)

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

        debug = new Pane({ title: "CONTROLS", expanded: true })
        debug.addSeparator()

        camera = debug.addFolder({ title: "Camera", expanded: false })
        camera.addInput(@camera.position, "x", { min: -20, max: 20, step: .01 })
        camera.addInput(@camera.position, "y", { min: -20, max: 20, step: .01 })
        camera.addInput(@camera.position, "z", { min: -20, max: 20, step: .01 })

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
        loaders["font"]    = new THREE.FontLoader()

        dracoLoader = new DRACOLoader()
        dracoLoader.setDecoderPath("./scripts/tools/Scene/draco/")
        
        gltfLoader  = new GLTFLoader()
        gltfLoader.setDRACOLoader(dracoLoader)

        loaders["gltf"]    = gltfLoader

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



