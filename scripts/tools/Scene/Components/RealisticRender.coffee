# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @config = {
            envMapIntensity: 4.6
        }

        if @options.debug then @debug()

    
    init: ->

        @createLights()

        cubeTextureLoader = new THREE.CubeTextureLoader()
        @environmentMap = cubeTextureLoader.load([
            "./scripts/tools/Scene/textures/environmentMaps/0/px.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/nx.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/py.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/ny.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/pz.jpg",
            "./scripts/tools/Scene/textures/environmentMaps/0/nz.jpg"
        ])

        @environmentMap.encoding = THREE.sRGBEncoding
        @options.scene.background  = @environmentMap
        @options.scene.environment = @environmentMap


        @options.loaders.gltf.load("./scripts/tools/Scene/models/Burger/glTF/hamburger.glb", ((gltf) =>

                @helmet = gltf.scene
                @helmet.scale.set(10, 10, 10)
                @helmet.position.set(0, -4, 0)
                @helmet.rotation.y = Math.PI * 0.5
                @options.scene.add @helmet

                @updateAllMaterials()
            )
        )

        # Start at 22:50


    updateAllMaterials: ->
        @options.scene.traverse (child) =>
            if child instanceof THREE.Mesh && child.material instanceof THREE.MeshStandardMaterial
                child.material.envMapIntensity = @config.envMapIntensity
                child.material.needsUpdate = true
                child.castShadow = true
                child.receiveShadow = true


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "Realistic Render", expanded: true })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        # light = @debugFolder.addFolder({ title: "Light", expanded: false })
        # light.addInput(@directionalLight, "intensity", { min: 0, max: 10, step: 0.001 })
        # light.addInput(@directionalLight.position, "x", { min: -5, max: 5, step: 0.001 })
        # light.addInput(@directionalLight.position, "y", { min: -5, max: 5, step: 0.001 })
        # light.addInput(@directionalLight.position, "z", { min: -5, max: 5, step: 0.001 })

        # helmet = @debugFolder.addFolder({ title: "Helmet", expanded: false })
        # helmet.addInput(@helmet.rotation, "y", { min: -Math.PI, max: Math.PI, step: 0.001, label: "rotationY" })
        # helmet.addInput(@config, "envMapIntensity", { min: 0, max: 20, step: 0.1 }).on("change", (v) => @updateAllMaterials())



    # ==================================================
    # > UTILS
    # ==================================================
    createLights: ->

        @directionalLight = new THREE.DirectionalLight(0xffffff, 1)
        @directionalLight.position.set(0.25, 3, -2.25)
        @directionalLight.castShadow = true
        @directionalLight.shadow.camera.far = 15
        @directionalLight.shadow.mapSize.set(1024, 1024)
        @options.scene.add(@directionalLight)

        # directionalLightHelper = new THREE.CameraHelper(@directionalLight.shadow.camera)
        # @options.scene.add(directionalLightHelper)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->