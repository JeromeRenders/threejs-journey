# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        super()

        @updateCameraPosition({ x: 6, y: 4, z: 8 })

        # Main light
        @mainLight = @createMainLight()
        @options.scene.add(@mainLight)

        # Secondary light
        @secondaryLight = @createSecondaryLight()
        @options.scene.add(@secondaryLight)

        # Door light
        @doorLight = @createDoorLight()
        @options.scene.add(@doorLight)

        # House
        @house = @createHouse()
        @options.scene.add @house

        # Graves
        @graves = @createGraves()
        @options.scene.add @graves

        # Ground
        @ground = @createGround()
        @options.scene.add @ground

        # Ghosts
        @ghost1 = @createGhost("#ff00ff", 2, 3)
        @ghost2 = @createGhost("#00ffff", 2, 3)
        @ghost3 = @createGhost("#ffff00", 2, 3)
        @options.scene.add @ghost1, @ghost2, @ghost3

        if @options.debug then @debug()

    debug: ->
        folder = @options.debug.addFolder({ title: "Haunted House", expanded: true })

        ambientLight = folder.addFolder({ title: "Ambient light", expanded: false })
        ambientLight.addInput(@mainLight, "intensity", { min: 0, max: 1, step: .01 })

        light = folder.addFolder({ title: "Light", expanded: false })
        light.addInput(@secondaryLight, "intensity", { min: 0, max: 1, step: .01 })
        light.addInput(@secondaryLight.position, "x", { min: -5, max: 15, step: .01 })
        light.addInput(@secondaryLight.position, "y", { min: -5, max: 15, step: .01 })
        light.addInput(@secondaryLight.position, "z", { min: -5, max: 15, step: .01 })


    createHouse: ->
        house = new THREE.Group()

        bricksAmbientOcclusionTexture = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/bricks/ambientOcclusion.jpg")
        bricksColorTexture            = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/bricks/color.jpg")
        bricksNormalTexture           = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/bricks/normal.jpg")
        bricksRoughnessTexture        = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/bricks/roughness.jpg")

        wallsGeometry = new THREE.BoxBufferGeometry(4, 2.5, 4)
        wallsGeometry.addAttribute("uv2", new THREE.BufferAttribute(wallsGeometry.attributes.uv.array, 2))
        wallsMaterial = new THREE.MeshStandardMaterial({
            shininess:    0
            metalness:    0
            map:          bricksColorTexture
            aoMap:        bricksAmbientOcclusionTexture
            normalMap:    bricksNormalTexture
            roughnessMap: bricksRoughnessTexture
        })
        @walls = new THREE.Mesh(wallsGeometry, wallsMaterial)
        @walls.position.y = 2.5 / 2
        @walls.castShadow = true
        house.add @walls

        roofGeometry = new THREE.ConeBufferGeometry(4, 1, 4)
        roofMaterial = new THREE.MeshStandardMaterial({ color: "#b35f45", shininess: 0, metalness: 0 })
        @roof = new THREE.Mesh(roofGeometry, roofMaterial)
        @roof.position.y = 2.5 + 0.5
        @roof.rotation.y = Math.PI / 4
        @roof.castShadow = true
        house.add @roof


        doorAlphaTexture            = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/alpha.jpg")
        doorAmbientOcclusionTexture = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/ambientOcclusion.jpg")
        doorColorTexture            = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/color.jpg")
        doorHeightTexture           = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/height.jpg")
        doorMetalnessTexture        = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/metalness.jpg")
        doorNormalTexture           = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/normal.jpg")
        doorRoughnessTexture        = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/door/roughness.jpg")

        doorGeometry = new THREE.PlaneBufferGeometry(2.2, 2.2, 100, 100)
        doorGeometry.addAttribute("uv2", new THREE.BufferAttribute(doorGeometry.attributes.uv.array, 2))
        doorMaterial = new THREE.MeshStandardMaterial({
            shininess:    0
            map:               doorColorTexture
            alphaMap:          doorAlphaTexture
            transparent:       true
            aoMap:             doorAmbientOcclusionTexture
            displacementMap:   doorHeightTexture
            displacementScale: .1
            normalMap:         doorNormalTexture
            metalnessMap:      doorMetalnessTexture
            roughnessMap:      doorRoughnessTexture
        })
        @door = new THREE.Mesh(doorGeometry, doorMaterial)
        @door.position.y = 2 / 2
        @door.position.z = (4 / 2) + 0.01
        house.add @door

        bushGeometry = new THREE.SphereBufferGeometry(1, 16, 16)
        bushMaterial = new THREE.MeshStandardMaterial({ color: "#89c854", shininess: 0, metalness: 0 })

        @bush1 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush1.scale.set(.5, .5, .5)
        @bush1.position.set(1.1, .2, 2.2)
        @bush1.castShadow = true
        house.add @bush1

        @bush2 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush2.scale.set(.25, .25, .25)
        @bush2.position.set(1.5, .1, 2.1)
        @bush2.castShadow = true
        house.add @bush2

        @bush3 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush3.scale.set(.4, .4, .4)
        @bush3.position.set(-.8, .1, 2.2)
        @bush3.castShadow = true
        house.add @bush3

        @bush4 = new THREE.Mesh(bushGeometry, bushMaterial)
        @bush4.scale.set(.15, .15, .15)
        @bush4.position.set(-1, .05, 2.6)
        @bush4.castShadow = true
        house.add @bush4

        return house

    createGraves: ->
        graves = new THREE.Group()

        graveGeometry = new THREE.BoxBufferGeometry(.6, .8, .2)
        graveMaterial = new THREE.MeshStandardMaterial({ color: "#b2b6b1" })

        for i in [0...50]
            angle = Math.random() * Math.PI * 2
            radius = 4 + Math.random() * 5
            x = Math.sin(angle) * radius
            z = Math.cos(angle) * radius

            grave = new THREE.Mesh(graveGeometry, graveMaterial)
            grave.position.set(x, .3, z)
            grave.rotation.y = (Math.random() - .5) * .4
            grave.rotation.z = (Math.random() - .5) * .4
            grave.castShadow = true
            graves.add grave

        return graves

    createGround: ->
        grassAmbientOcclusionTexture = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/grass/ambientOcclusion.jpg")
        grassColorTexture            = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/grass/color.jpg")
        grassNormalTexture           = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/grass/normal.jpg")
        grassRoughnessTexture        = @options.loaders.texture.load("./scripts/tools/Scene/textures/haunted-house/grass/roughness.jpg")

        repeat = 24
        grassAmbientOcclusionTexture.repeat.set(repeat, repeat)
        grassColorTexture.repeat.set(repeat, repeat)
        grassNormalTexture.repeat.set(repeat, repeat)
        grassRoughnessTexture.repeat.set(repeat, repeat)

        grassAmbientOcclusionTexture.wrapS = THREE.RepeatWrapping
        grassAmbientOcclusionTexture.wrapT = THREE.RepeatWrapping
        grassColorTexture.wrapS            = THREE.RepeatWrapping
        grassColorTexture.wrapT            = THREE.RepeatWrapping
        grassNormalTexture.wrapS           = THREE.RepeatWrapping
        grassNormalTexture.wrapT           = THREE.RepeatWrapping
        grassRoughnessTexture.wrapS        = THREE.RepeatWrapping
        grassRoughnessTexture.wrapT        = THREE.RepeatWrapping

        geometry = new THREE.PlaneBufferGeometry(60, 60)
        geometry.addAttribute("uv2", new THREE.BufferAttribute(geometry.attributes.uv.array, 2))
        material = new THREE.MeshStandardMaterial({
            shininess:    0
            metalness:    0
            map:          grassColorTexture
            aoMap:        grassAmbientOcclusionTexture
            normalMap:    grassNormalTexture
            roughnessMap: grassRoughnessTexture
        })
        ground = new THREE.Mesh(geometry, material)
        ground.receiveShadow = true

        ground.rotation.x = -Math.PI / 2

        return ground

    createGhost: (color, intensity = 2, distance = 3) ->
        ghost = new THREE.PointLight(color, intensity, distance)
        ghost.castShadow = true

        return ghost

    createMainLight: ->
        light = new THREE.AmbientLight("#b9d4ff", .12)

        return light

    createSecondaryLight: ->
        light = new THREE.DirectionalLight("#b9d4ff", .5)
        light.position.set(4, 5, -2)
        light.castShadow = true

        return light

    createDoorLight: ->
        light = new THREE.PointLight("#ff7d46", 1, 7)
        light.position.set(0, 2.2, 2.7)
        light.castShadow = true

        return light


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        ghost1Angle = elapsedTime * .5
        @ghost1.position.x = Math.cos(ghost1Angle) * 4
        @ghost1.position.z = Math.sin(ghost1Angle) * 4
        @ghost1.position.y = Math.sin(ghost1Angle * 3)

        ghost2Angle = -elapsedTime * .3
        @ghost2.position.x = Math.cos(ghost2Angle) * 6
        @ghost2.position.z = Math.sin(ghost2Angle) * 6
        @ghost2.position.y = Math.sin(ghost2Angle * 4) * Math.sin(ghost2Angle * 2.5)

        ghost3Angle = -elapsedTime * .18
        @ghost3.position.x = Math.cos(ghost3Angle) * (7 + Math.sin(elapsedTime * .32))
        @ghost3.position.z = Math.sin(ghost3Angle) * (7 + Math.sin(elapsedTime * .5))
        @ghost3.position.y = Math.sin(ghost3Angle * 3) + Math.sin(elapsedTime * 2.5)
