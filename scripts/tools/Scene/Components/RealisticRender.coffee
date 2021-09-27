# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @createLights()

        cubeTextureLoader = new THREE.CubeTextureLoader()
        environmentMap = cubeTextureLoader.load([
            "./scripts/tools/Scene/textures/environmentMaps/0/px.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/nx.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/py.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/ny.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/pz.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/nz.jpg"
        ])

        @options.scene.background = environmentMap


        @options.loaders.gltf.load("./scripts/tools/Scene/models/FlightHelmet/glTF/FlightHelmet.gltf", ((gltf) =>

                @helmet = gltf.scene
                @helmet.scale.set(10, 10, 10)
                @helmet.position.set(0, -4, 0)
                @helmet.rotation.y = Math.PI * 0.5
                @options.scene.add @helmet

                if @options.debug then @debug()

            )
        )

        # Start at 22:50



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "Realistic Render", expanded: true })

        light = @debugFolder.addFolder({ title: "Light", expanded: false })
        light.addInput(@directionalLight, "intensity", { min: 0, max: 10, step: 0.001 })
        light.addInput(@directionalLight.position, "x", { min: -5, max: 5, step: 0.001 })
        light.addInput(@directionalLight.position, "y", { min: -5, max: 5, step: 0.001 })
        light.addInput(@directionalLight.position, "z", { min: -5, max: 5, step: 0.001 })

        helmet = @debugFolder.addFolder({ title: "Helmet", expanded: false })
        helmet.addInput(@helmet.rotation, "y", { min: -Math.PI, max: Math.PI, step: 0.001, label: "rotationY" })



    # ==================================================
    # > UTILS
    # ==================================================
    createLights: ->

        @directionalLight = new THREE.DirectionalLight(0xffffff, 1)
        @directionalLight.position.set(0.25, 3, -2.25)
        @options.scene.add(@directionalLight)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->