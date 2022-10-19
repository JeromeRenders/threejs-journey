# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @title = "7. Animated 3D model"

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 4, y: 2, z: 4 })

        @mesh = new THREE.Group()

        @previousTime = 0

        floor = new THREE.Mesh(
            new THREE.PlaneGeometry(10, 10),
            new THREE.MeshStandardMaterial({
                color: "#444444",
                metalness: 0,
                roughness: 0.5,
                side: THREE.DoubleSide
            })
        )
        floor.receiveShadow = true
        floor.rotation.x = -Math.PI * 0.5
        @mesh.add(floor)

        @createLights()

        @mixer = null
        @options.loaders.gltf.load("./scripts/tools/Scene/models/Fox/glTF/Fox.gltf", (gltf) =>
            @animations = gltf.animations
            @mixer = new THREE.AnimationMixer(gltf.scene)

            gltf.scene.scale.set(0.025, 0.025, 0.025)
            @mesh.add gltf.scene
        )

        @options.scene.add(@mesh)



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addButton({ title: "Idle" }).on("click", (e) =>
            if @action then @action.stop()
            @action = @mixer.clipAction(@animations[0])
            @action.setDuration(3)
            @action.play()
        )
        @debugFolder.addButton({ title: "Walk" }).on("click", (e) =>
            if @action then @action.stop()
            @action = @mixer.clipAction(@animations[1])
            @action.setDuration(1)
            @action.play()
        )
        @debugFolder.addButton({ title: "Run" }).on("click", (e) =>
            if @action then @action.stop()
            @action = @mixer.clipAction(@animations[2])
            @action.setDuration(.9)
            @action.play()
        )
        @debugFolder.addButton({ title: "Stop" }).on("click", (e) =>
            if @action then @action.stop()
        )


    # ==================================================
    # > UTILS
    # ==================================================
    createLights: ->
        ambientLight = new THREE.AmbientLight(0xffffff, 0.8)
        @mesh.add(ambientLight)

        directionalLight = new THREE.DirectionalLight(0xffffff, 0.6)
        directionalLight.castShadow = true
        directionalLight.shadow.mapSize.set(1024, 1024)
        directionalLight.shadow.camera.far = 15
        directionalLight.shadow.camera.left = -7
        directionalLight.shadow.camera.top = 7
        directionalLight.shadow.camera.right = 7
        directionalLight.shadow.camera.bottom = -7
        directionalLight.position.set(5, 5, 5)
        @mesh.add(directionalLight)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        deltaTime = elapsedTime - @previousTime
        @previousTime = elapsedTime

        if @mixer then @mixer.update(deltaTime)