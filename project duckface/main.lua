camera = require "camera"

function rekt(x,y,w,h,color)
	 love.graphics.setColor(color)
	 love.graphics.rectangle("fill", x, y, w, h )
	 love.graphics.setColor(255,255,255)
end
function inc(x,n)
	x = x + n
end
function love.load()

	loadingScreen=love.graphics.newImage('agdg.png')	
	
	love.graphics.clear()
	love.graphics.draw(loadingScreen,0,0)
	love.graphics.present()
	love.graphics.setColor(255,255,255)

	camerot = 0
   eh=1
   heartx,hearty=2.3,2.3
   Gheartx,Ghearty=heartx,hearty
	want=0.75
	bullets={}
	bbullets={}
	bulletdir={}
	curmage = love.graphics.newImage('hotshot.png')
	cursor = love.image.newImageData('hotshot.png')
	blackBullet = love.graphics.newImage('spade.png')
	background=love.graphics.newImage('bg.png')
	bg = love.graphics.newImage('big.png')
	
   player = {

	image = love.graphics.newImage("avatar.png"),
	w = love.graphics.newImage("avatar.png"):getWidth(),
	h = love.graphics.newImage("avatar.png"):getHeight(),
	range = 320,
	damage = 5
	}
	
	bullet = love.graphics.newImage("bullet.png")
   w = love.graphics.getWidth()
	h = love.graphics.getHeight()
   
	enemy = love.graphics.newImage('bad.png')
	enemies = {}
	
	bw = bullet:getWidth()
	bh = bullet:getHeight()
	x,y = w/2,h/2
	world = love.physics.newWorld(0,0,True)
		world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	Edamage=3
	
	playerSpeed=280
	bulletSpeed=480
	bbulletSpeed=450
	Pdex = 0.09
	GPdex = Pdex
	Edex = 0.1
	
	origin_list={}
	
	Pr_time=0
	Er_time=0
	playorbobo=love.physics.newBody(world,x,y,'static')
	playorshep=love.physics.newRectangleShape(player.w,player.h)
	playfix= love.physics.newFixture(playorbobo,playorshep)
	hp={}
	hp[playorbobo]=100
	rads={}
	enemy_range = 300
	ca,cb=playfix,playfix
	
   cam = camera(playorbobo:getX(),playorbobo:getY())
	rad=0
	rotator=0.0
	
	range_list={}
	
	muhheart=love.graphics.newImage('centralded.png')
	
	speeds={}
	timeFactor=1
	GplayerSpeed=playerSpeed
	winner=true
	
	
	scale=0.75
	nowinc=0
	incremental = 0.01
	spinarak = 0
	level=0
	prepared = true
	zmoom=false
	c = 0
	automatic=true
end

function love.update(dt)
	
	
	spinarak = spinarak + dt*timeFactor
	
	if tablelength(enemies) == 0 then
		winner=true
	end
	if want ~= scale then
		if want < scale then 
			nowinc = - incremental 
		elseif want > scale then 
			nowinc = incremental end
		
		scale = scale + nowinc
		
	end
	
	--range shit
	
	for thing,range in pairs(range_list) do
		Range=range
		bx,by=thing:getPosition()
		ox,oy=origin_list[thing].x,origin_list[thing].y
		
		xd = ox - bx
		yd = oy - by
		Distance = math.sqrt(xd*xd + yd*yd)
	
		if Distance >= range then
			if in_list(thing,bullets) then
				table.remove(bullets,index(bullets,thing))
				thing:destroy()
				
			elseif in_list(thing,bbullets) then
				table.remove(bbullets,index(bbullets,thing))
				thing:destroy()
			end
		end
		
	end
	
	
	cam:zoomTo(scale)
	world:update(dt*timeFactor)
	cam:rotate(dt*rotator*timeFactor)
	
	
	delete={}
	if not winner then
		rotator=(100-hp[playorbobo])/30
	end
	for n,ene in ipairs(enemies) do
		rads[ene]=(50-hp[ene])/30*timeFactor
	end
	rad = rad + dt*rotator*timeFactor
	
	Pr_time = Pr_time - dt*timeFactor
	Er_time = Er_time - dt*timeFactor
	
	if hp[playorbobo]<=0 then
		love.event.quit( )
	end
   if love.keyboard.isDown("d") then
		playorbobo:setX(playorbobo:getX() + playerSpeed*dt*timeFactor*math.cos(rad+math.rad(0)))
		playorbobo:setY(playorbobo:getY() - playerSpeed*dt*timeFactor*math.sin(rad+math.rad(0)))
	elseif love.keyboard.isDown("a") then
		playorbobo:setX(playorbobo:getX() + playerSpeed*dt*timeFactor*math.cos(rad+math.rad(180)))
		playorbobo:setY(playorbobo:getY() - playerSpeed*dt*timeFactor*math.sin(rad+math.rad(180)))
	end
	
	if love.keyboard.isDown("s") then
		playorbobo:setX(playorbobo:getX() - playerSpeed*dt*timeFactor*math.cos(rad+math.rad(90)))
		playorbobo:setY(playorbobo:getY() + playerSpeed*dt*timeFactor*math.sin(rad+math.rad(90)))
	
	
	
	elseif love.keyboard.isDown("w") then
		playorbobo:setX(playorbobo:getX() - playerSpeed*dt*timeFactor*math.cos(rad+math.rad(270)))
		playorbobo:setY(playorbobo:getY() + playerSpeed*dt*timeFactor*math.sin(rad+math.rad(270)))

	end
	
	for i, bt in ipairs(bullets) do
      if bt:getX()-bw*1.5 > w or bt:getX() < 0 then
			table.remove(bullets,i)
			bt:destroy()
		elseif bt:getY() > h or bt:getY() < 0 then
			table.remove(bullets,i)
			bt:destroy()
		end
   end
	
	for i, bt in ipairs(bbullets) do
      if bt:getX() > w or bt:getX()+bw < 0 then
			table.remove(bbullets,i)
			bt:destroy()
		elseif bt:getY() > h or bt:getY()+bh < 0 then
			table.remove(bbullets,i)
			bt:destroy()
		end
   end
	
	dx,dy = playorbobo:getX() - cam.x, playorbobo:getY() - cam.y
	cam:move(dx, dy)
	if winner then
				x=math.random(0,w)
				y=math.random(0,h)
				xspd=math.cos(math.random(0,w))
				yspd=math.sin(math.random(0,h))
				
				heart= love.physics.newBody(world, playorbobo:getX(), playorbobo:getY(), "kinematic")
				mx = math.abs(x)
				my = math.abs(y)
				
				heartfart = love.physics.newRectangleShape(bullet:getWidth(),bullet:getHeight())
				heartdart = love.physics.newFixture(heart,heartfart)
				angle = math.atan2((my-curmage:getHeight()/2 - playorbobo:getY()), (mx-curmage:getWidth()/2 - playorbobo:getX()))
				
				
				bDx = bulletSpeed  *2* math.cos(angle) 
				bDy = bulletSpeed  *2* math.sin(angle) 
				
				heart:setLinearVelocity(bDx,bDy)
				bulletdir[heart]=angle
				table.insert(bullets,heart)
				count_dt = true
				if automatic then
					camerot = cam.rot/math.pi/2
					if count_dt  and rotator <= 0  then
						c = c + dt/10
					end
					pSHIT =  (camerot* math.pow(c,2) + -camerot*100*c )
					
					rotator = pSHIT
				end
				
				if cam.rot <= 0.01  then
					automatic = false
					rotator = rotator - dt
				else
					automatic = true
					
				end
				
				if cam.rot <= 0 then
					rotator = 0
					cam.rot = 0
					winner = false
					level = level + 1
					prepared = false
					hp[playorbobo] = 100
					rad = 0
					count_dt = false
					c=0
				end
				
	end			
	if not prepared then
			
			for i=1,level do
				math.random()
				
				ene = love.physics.newBody(world, math.random(w),math.random(h), 'dynamic')
				hp[ene]=50
				
				rads[ene]=0
				enes = love.physics.newRectangleShape(enemy:getWidth(), enemy:getHeight())
				enaynay = love.physics.newFixture(ene,enes)
				enaynay:setGroupIndex(0)
				enaynay:setCategory(7,3)
				enaynay:setMask(7)
				enaynay:getBody():setMass(enaynay:getBody():getMass()*1.25)
				
				table.insert(enemies,ene)
				
			end
			
			prepared = true
	end
			
	
	
	if Pr_time<=0  then
		if not winner then
			heart= love.physics.newBody(world, playorbobo:getX(), playorbobo:getY(), "kinematic")
			heart:setBullet(True)
			
			heartfart = love.physics.newRectangleShape(bullet:getWidth(),bullet:getHeight())
			heartdart = love.physics.newFixture(heart,heartfart)
			mx,my = cam:worldCoords(love.mouse.getPosition())
			
			angle = math.atan2((my-curmage:getHeight()/2 - playorbobo:getY()), (mx-curmage:getWidth()/2 - playorbobo:getX()))
		 	
			bulletDx = bulletSpeed * math.cos(angle) 
			bulletDy = bulletSpeed * math.sin(angle)
			heart:setLinearVelocity(bulletDx,bulletDy)
			
			bulletdir[heart]=angle
			range_list[heart]=player.range
			origin_list[heart]={x=playorbobo:getX(),y=playorbobo:getY()}
			
			heartdart:setGroupIndex(-1)
			table.insert(bullets,heart)
			Pr_time = Pdex
		end

		
	end


	
	if Er_time<=0 then	
		for _, e in ipairs(enemies) do

			black= love.physics.newBody(world, e:getX(), e:getY(), "dynamic")
			black:setBullet(True)
			black:setInertia(10)
			black:setMass(0.1)
			blackbutt = love.physics.newRectangleShape(blackBullet:getWidth(),blackBullet:getHeight())
			blackfix = love.physics.newFixture(black,blackbutt)
			angle = math.atan2((playorbobo:getY() - e:getY()-enemy:getHeight()/2+player.h/2), (playorbobo:getX() - e:getX()-enemy:getWidth()/2+player.w/2)) 
			bbulletDx = bbulletSpeed * math.cos(angle) 
			bbulletDy = bbulletSpeed * math.sin(angle)
			black:setLinearVelocity(bbulletDx,bbulletDy)
			
			
			origin_list[black]={x=e:getX(),y=e:getY()}
			bulletdir[black]=angle
			range_list[black]=enemy_range
			
			blackfix:setGroupIndex( -2 )
			blackfix:setCategory( 7 )

			table.insert(bbullets,black)
			Er_time=Edex

		end
	
	end
		
		
		
	if love.mouse.isDown(2) then
		timeFactor = 0.5
		playerSpeed = GplayerSpeed * timeFactor*1.3
		Pdex = GPdex * 0.9
		zmoom=true
		if heartx > 0 and hearty > 0 then
			heartx,hearty = heartx - dt/scale/1.5, hearty - dt/scale/1.5
		end
	else
		timeFactor = 1
		playerSpeed = GplayerSpeed * timeFactor*1.3
		Pdex = GPdex
		zmoom=false
		if heartx<Gheartx then
			heartx = heartx + dt
		end
		if hearty<Ghearty then
			hearty = hearty + dt
			
		end
	end
	
	
	
	for i, bt in ipairs(bullets) do
		

		
		if ca:getBody()==bt or cb:getBody()==bt then
			
			table.remove(bullets,i)
			table.insert(delete,bt)
				
			
		end
		
		for _,e in pairs(enemies) do
			rads[e] = rads[e] 
		
		end
		for n,ene in ipairs(enemies) do
			if (ca:getBody()==bt and cb:getBody()==ene) or (cb:getBody() == bt and ca:getBody() == ene) then
				hp[ene]= hp[ene] - player.damage
				
			end
		end
	end

	for n, ene in ipairs(enemies) do
		yex=0
		yey=0
		cov=100*(2.5-hp[ene]/50)
		
		
		if ene:getX()<0 then
			yex=cov
		
		elseif ene:getX()>=w+enemy:getWidth() then
			yex=-cov
		end
		if ene:getY()<0 then
			yey=cov
		
		elseif ene:getY()>=h-enemy:getHeight() then
			yey=-cov
		end
		if yex ~= 0 then
			ene:applyLinearImpulse(yex,0,0,0)
		end
		if yey ~= 0 then
			ene:applyLinearImpulse(0,yey,0,0)
		end
	end
	
	
	
	
	
	
	
	
	for i, bt in ipairs(bbullets) do
			
		
		if (ca:getBody()==bt and cb:getBody()==playorbobo) or (ca:getBody()==playorbobo and cb:getBody()==bt) then
			hp[playorbobo] = hp[playorbobo] - Edamage

		end
		
	end
	

	
	for n,bby in ipairs(bbullets) do
			if (ca:getBody()==bby and cb:getBody()==playorbobo) or (cb:getBody()==bby and ca:getBody()==playorbobo) then
				table.insert(delete,bby)
				table.remove(bbullets,n)
			end
		
	end
	for _,bt in ipairs(delete) do
		bt:destroy()
		
   end
	
	for k,v in pairs(bulletdir) do
		found=false
		
		for i,bt in ipairs(bullets) do
			if bt==k then
				found=true
				
				break
			end	
		end
		if not found then
			for i,bt in ipairs(bbullets) do
				if bt==k then
					found=true
					
					break
				end
			end
		end
		
		if not found then
			bulletdir[k]=nil
			
		end
	end
	
	delete={}
	
	for i,ene in ipairs(enemies) do
		if hp[ene]<=0 then
			table.insert(delete,ene)
		end
	end
	
	for _,ene in ipairs(delete) do
		table.remove(enemies,index(enemies,ene))
		table.remove(hp,index(hp,ene))
		table.remove(rads,index(rads,ene))
	end
	
	for thing,range in pairs(range_list) do
		if not(in_list(thing,bullets)) and not(in_list(thing,bbullets)) then
			range_list[thing]=nil
		
		end
	end
	for thing,orange in pairs(origin_list) do
		if not(in_list(thing,bullets)) and not(in_list(thing,bbullets)) then
			origin_list[thing]=nil
			
		end
	
	end
end




function in_list(item,list)
	for n,m in ipairs(list) do
		if m==item then
			return true
		end
	end
	return false
end

function love.mousepressed(x,y,button) 
	
	if button == 'l' then
		mx,my=cam:worldCoords(love.mouse.getPosition())
		playorbobo:setX(mx-player.w/2)
		playorbobo:setY(my-player.h/2)
	end


	if want == scale then
		
		if scale<1.55 then
			if button == "wu" then
				want= scale + incremental*5
			end
		end	
		if scale>0.55 then
			if button == "wd" then
				want = scale - incremental*5
			end
		end	
	end
	
	
	
	
end
function love.draw()
	
	love.graphics.draw(bg,0,0)
	cam:attach()
	

	love.graphics.draw(background,0,0) 
	
	for eh, bt in pairs(bbullets) do
		radeon=0
		for k,v in pairs(bulletdir) do
			if k==bt then
				radeon=bulletdir[k]
				break
			end
		end

		love.graphics.draw(blackBullet, bt:getX(), bt:getY(),radeon, 1, 1, blackBullet:getWidth()/2, blackBullet:getHeight()/2)
   end
	for eh,e in ipairs(enemies) do


		love.graphics.draw(enemy, e:getX(),e:getY(), rads[e]*spinarak*20, 1, 1, enemy:getWidth()/2,enemy:getHeight()/2)


	end
	
	
	for eh, bt in pairs(bullets) do
		radeon=0
		for k,v in pairs(bulletdir) do
			if k==bt then
				radeon=bulletdir[k]
				break
			end
		end

		love.graphics.draw(bullet, bt:getX(), bt:getY(),radeon,1,1,bw/2,bh/2)
   end

	love.graphics.draw(player.image, playorbobo:getX(), playorbobo:getY(), 0, 1, 1, player.w/2,player.h/2)
	
	love.mouse.setCursor(love.mouse.newCursor(cursor, cursor:getWidth()/2, cursor:getHeight()/2))
 	  
   
	cam:detach()

	
	
		camx,camy=cam:cameraCoords(playorbobo:getPosition())
		color={212,0,0}
		love.graphics.draw(muhheart,camx,camy,0,heartx,hearty,muhheart:getWidth()/2,muhheart:getHeight()/2)
		
		rekt(0,0,(w-muhheart:getWidth()*heartx)/2,h,color)
		rekt(0,0,w,(h-muhheart:getHeight()*hearty)/2,color)
		rekt(0,h,w,-((h-muhheart:getHeight()*hearty)/2),color)
		rekt(w,0,-((w-muhheart:getWidth()*heartx)/2),h,color)
		
	
	
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 5, 15)
	love.graphics.print('Body count: '..tostring(world:getBodyCount()) ,5 ,30 )
	love.graphics.print('Current level: '..tostring(level),5,45)
	love.graphics.print('ROTATOR : '..tostring(rotator),5,60)
	love.graphics.print('C : '..tostring(c),5,75)
	love.graphics.print('CAMEROT: '..camerot,5,90)
	love.graphics.print('Cam dot rot: '..cam.rot,5,110)


	
	


	
	
	
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function beginContact(a, b, coll)
    
	 ca=a
	 cb=b
	 
end
function endContact(a, b, coll)
	ca,cb=playfix,playfix
end
function preSolve(a, b, coll)
	
end
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end
function index(Table,element)
	for i,e in ipairs(Table) do
		if e == element then
			return i
		end
	end
end
-- 100*dt means a second