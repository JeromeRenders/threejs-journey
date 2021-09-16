# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"
import CANNON        from "cannon"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        @oldElapsedTime  = 0
        @objectsToUpdate = []
        @sounds =
            hit: new Audio("./scripts/tools/Scene/sounds/hit.mp3")

        @setupWorld()
        @setupMeshes()

        @createFloor()
        @createLights()

        @debug()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        folder = @options.debug.addFolder({ title: "Physics", expanded: true })

        folder.addButton({ title: "Create sphere", label: "createSphere" }).on("click", =>
            @createSphere(Math.random() * 0.5, {
                x: (Math.random() - 0.5) * 3,
                y: 3,
                z: (Math.random() - 0.5) * 3
            })
        )
        folder.addButton({ title: "Create box", label: "createBox" }).on("click", =>
            @createBox(Math.random(), Math.random(), Math.random(), {
                x: (Math.random() - 0.5) * 3,
                y: 3,
                z: (Math.random() - 0.5) * 3
            })
        )
        folder.addButton({ title: "Reset", label: "reset" }).on("click", =>
            @reset()
        )


    # ==================================================
    # > UTILS
    # ==================================================
    playHitSound: (collision) ->
        impactStrength = collision.contact.getImpactVelocityAlongNormal()
        if impactStrength > 1.5
            @sounds.hit.volume = Math.random()
            @sounds.hit.currentTime = 0
            @sounds.hit.play()

    reset: ->
        for obj in @objectsToUpdate
            obj.body.removeEventListener "collide", (e) => @playHitSound(e)
            @world.removeBody(obj.body)

            @options.scene.remove obj.mesh


    # ==================================================
    # > SETUP BASE
    # ==================================================
    setupWorld: ->

        # Create the world
        @world = new CANNON.World()
        @world.gravity.set(0, -9.82, 0)

        # Optimisation - Avoid objects checking all other objects
        @world.broadphase = new CANNON.SAPBroadphase(@world)
        # Optimisation - Allow objects to sleep when not moving
        @world.allowSleep = true

        # Create a default material
        @defaultMaterial = new CANNON.Material("default")
        @world.addContactMaterial(new CANNON.ContactMaterial(@defaultMaterial, @defaultMaterial, {
            friction: .1
            restitution: .9
        }))

    setupMeshes: ->
        # Sphere components
        @sphereGeometry = new THREE.SphereBufferGeometry(1, 20, 20)
        @sphereMaterial = new THREE.MeshStandardMaterial({
            metalness: .3
            roughness: .4
        })

        # Box components
        @boxGeometry = new THREE.BoxBufferGeometry(1, 1, 1)
        @boxMaterial = new THREE.MeshStandardMaterial({
            metalness: .3
            roughness: .4
        })


    # ==================================================
    # > CREATE COMPONENTS
    # ==================================================
    createSphere: (radius, position) ->

        # THREE.JS
        mesh = new THREE.Mesh(@sphereGeometry, @sphereMaterial)
        mesh.scale.set(radius, radius, radius)
        mesh.castShadow = true
        mesh.position.copy(position)
        @options.scene.add(mesh)

        # CANNON.JS
        shape = new CANNON.Sphere(radius)
        body = new CANNON.Body({
            mass:     1
            position: new CANNON.Vec3(0, 3, 0)
            shape:    shape
            material: @defaultMaterial
        })
        body.position.copy(position)
        body.addEventListener "collide", (e) => @playHitSound(e)
        @world.addBody(body)

        # Save the objects to update
        @objectsToUpdate.push({
            mesh: mesh
            body: body
        })

    createBox: (width, height, depth, position) ->

        # THREE.JS
        mesh = new THREE.Mesh(@boxGeometry, @boxMaterial)
        mesh.scale.set(width, height, depth)
        mesh.castShadow = true
        mesh.position.copy(position)
        @options.scene.add(mesh)

        # CANNON.JS
        shape = new CANNON.Box(new CANNON.Vec3(width * 0.5, height * 0.5, depth * 0.5))
        body = new CANNON.Body({
            mass:     1
            position: new CANNON.Vec3(0, 3, 0)
            shape:    shape
            material: @defaultMaterial
        })
        body.position.copy(position)
        body.addEventListener "collide", (e) => @playHitSound(e)
        @world.addBody(body)

        # Save the objects to update
        @objectsToUpdate.push({
            mesh: mesh
            body: body
        })

    createFloor: ->

        # CANNON.JS
        floorShape = new CANNON.Plane()
        @floorBody = new CANNON.Body({
            mass: 0
            shape: floorShape
            material: @defaultMaterial
        })
        @floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(-1, 0, 0), Math.PI * .5)
        @world.addBody(@floorBody)

        # THREE.JS
        @floor = new THREE.Mesh(
            new THREE.PlaneGeometry(10, 10)
            new THREE.MeshStandardMaterial({
                color: "#777777"
                metalness: .3
                roughness: .4
            })
        )
        @floor.receiveShadow = true
        @floor.rotation.x = -Math.PI * .5
        @options.scene.add(@floor)

    createLights: ->
        ambientLight = new THREE.AmbientLight(0xffffff, .7)
        @options.scene.add(ambientLight)

        directionalLight = new THREE.DirectionalLight(0xffffff, .2)
        directionalLight.castShadow = true
        directionalLight.shadow.mapSize.set(1024, 1024)
        directionalLight.shadow.camera.far = 15
        directionalLight.shadow.camera.left = -7
        directionalLight.shadow.camera.top = 7
        directionalLight.shadow.camera.right = 7
        directionalLight.shadow.camera.bottom = -7
        directionalLight.position.set(5, 5, 5)
        @options.scene.add(directionalLight)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        # Get the delta of time passed between last elapsed time
        deltaTime = elapsedTime - @oldElapsedTime
        @oldElapsedTime = elapsedTime

        # Update the Cannon.js world
        @world.step(1 / 60, deltaTime, 3)

        # Update the Three.js components from the Cannon.js world
        for obj in @objectsToUpdate
            obj.mesh.position.copy(obj.body.position)
            obj.mesh.quaternion.copy(obj.body.quaternion)