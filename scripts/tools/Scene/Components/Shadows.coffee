# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        bakedShadow = @options.loaders.texture.load("./scripts/tools/Scene/textures/shadows/simpleShadow.jpg")

        console.log bakedShadow
        
        @main = new THREE.AmbientLight(0xffffff, .5)
        @options.scene.add(@main)

        @point = new THREE.DirectionalLight(0xffffff, .5)
        @point.position.set(2, 2, -1)
        # @point.castShadow = true
        # @point.shadow.mapSize.width = 1024
        # @point.shadow.mapSize.height = 1024
        # @point.shadow.camera.near = 1
        # @point.shadow.camera.far = 15
        # # @point.shadow.radius = 10
        # # @pointCameraHelper = new THREE.CameraHelper(@point.shadow.camera)
        # # @options.scene.add @pointCameraHelper
        @options.scene.add(@point)


        @material = new THREE.MeshStandardMaterial()
        @material.metalness = 0
        @material.roughness = 0.7
        
        objectGeometry = new THREE.SphereBufferGeometry(1, 32, 32)
        @object = new THREE.Mesh(objectGeometry, @material)
        # @object.castShadow = true
        @options.scene.add @object

        planeGeometry = new THREE.PlaneBufferGeometry(8, 8)
        @plane = new THREE.Mesh(planeGeometry, @material)
        # @object.receiveShadow = true
        @plane.position.y = -1
        @plane.rotation.x = -Math.PI * .5
        @options.scene.add @plane

        @objectShadow = new THREE.Mesh(new THREE.PlaneBufferGeometry(3, 3), new THREE.MeshBasicMaterial({
            color: 0x000000
            transparent: true
            alphaMap: bakedShadow
        }))
        @objectShadow.position.y = @plane.position.y + .01
        @objectShadow.rotation.x = -Math.PI * .5
        @options.scene.add @objectShadow
    
        @debug()

    debug: ->
        folder = @options.debug.addFolder({ title: "Shadows", expanded: true })

        ambientLight = folder.addFolder({ title: "Ambient light", expanded: false })
        ambientLight.addInput(@main, "intensity", { min: 0, max: 1, step: .01 })

        light = folder.addFolder({ title: "Light", expanded: false })
        light.addInput(@point, "intensity", { min: 0, max: 1, step: .01 })
        light.addInput(@point.position, "x", { min: -5, max: 15, step: .01 })
        light.addInput(@point.position, "y", { min: -5, max: 15, step: .01 })
        light.addInput(@point.position, "z", { min: -5, max: 15, step: .01 })

        material = folder.addFolder({ title: "Material", expanded: false })
        material.addInput(@material, "metalness", { min: 0, max: 1, step: .01 })
        material.addInput(@material, "roughness", { min: 0, max: 1, step: .01 })



    onUpdate: (elapsedTime) ->
        @object.position.x = Math.cos elapsedTime * 2
        @object.position.z = Math.sin elapsedTime * 2
        @object.position.y = Math.abs Math.sin elapsedTime * 3.5

        @objectShadow.position.x = @object.position.x
        @objectShadow.position.z = @object.position.z
        @objectShadow.material.opacity = (1 - @object.position.y) * .8
        