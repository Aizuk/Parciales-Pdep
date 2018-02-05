class Invitado{
	var disfraz
	var edad
	var personalidad
	var fiesta
	constructor(_disfraz,_edad,_personalidad,_fiesta){
		disfraz = _disfraz
		edad = _edad
		personalidad = _personalidad
		fiesta = _fiesta
	}
	method cambiarDisfraz(otro) {disfraz = otro}
	method edad() = edad
	method sexy() = personalidad.sexy(self)
	method disfraz() = disfraz
	method satisfecho() = self.satisfecho(disfraz)
	method satisfecho(_disfraz) = _disfraz.puntuar() > 10
	method intercambiarDisfraz(otro) = if(self.cumpleCondiciones(otro)) {
		var aux = disfraz
		self.cambiarDisfraz(otro.disfraz())
		otro.cambiarDisfraz(aux)
	}
	method cumpleCondiciones(otro) = self.mismaFiesta(otro) && (!self.satisfecho() || !otro.satisfecho()) && self.satisfecho(otro.disfraz()) && otro.satisfecho(self.disfraz())
	method mismaFiesta(otro) = otro.fiesta() == fiesta 
}

class Caprichoso inherits Invitado{
	override method satisfecho() = super() && disfraz.nombrePar()
}

class Pretencioso inherits Invitado{
	override method satisfecho() = super() && disfraz.diasEdad()<30
}

class Numerologo inherits Invitado{
	var clave
	constructor(_clave,_disfraz,_edad,_personalidad,_fiesta) = super(_disfraz,_edad,_personalidad,_fiesta){
		clave = _clave
	}
	override method satisfecho() = super() && disfraz.puntuar()==clave
}

object alegre{
	method sexy(_) = false
}

object taciturno{
	method sexy(disfrazado) = disfrazado<30
}

object cambiante{
	var personalidades = [alegre,taciturno]
	method sexy(disfrazado) = personalidades.random({pers=>pers.sexy(disfrazado)})
}

class Disfraz{
	var nombre
	var fecha
	var caracteristicas = []
	constructor(_nombre,_fecha,_caracteristicas){
		nombre = _nombre
		fecha = _fecha
		caracteristicas = _caracteristicas
	}
	method puntuar(disfrazado) = 0+caracteristicas.sum({caracteristica=>caracteristica.puntos(disfrazado,self)})
}

class Gracioso{
	var nivelGracia
	constructor(nivel){
		nivelGracia = nivel
	}
	method puntos(disfrazado,disfraz) = if(disfrazado.edad()>50) return nivelGracia*3 else return nivelGracia
}

object tobaras{
	method puntos(disfrazado,disfraz) = if(disfraz.fecha()>=(disfrazado.fechaFiesta()+2)) return 5 else return 3
}

class Careta{
	var personaje
	constructor(_personaje){
		personaje = _personaje
	}
	method puntos(_,__) = personaje.puntos()
}

object sexy{
	method puntos(disfrazado,_) = if(disfrazado.sexy()) return 15 else return 2
}

class Fiesta{
	var fecha
	var asistentes
	constructor(_fecha,_asistentes){
		fecha = _fecha
		asistentes = _asistentes
	}
	method fecha() = fecha
	method bodrio() = asistentes.all({asist=>!(asist.satisfecho())})
	method mejorDisfraz() = asistentes.max({asist=>asist.puntos()}).disfraz()
	method agregarAsistente(nuevo) = if (self.cumpleCondiciones(nuevo)) {asistentes.add(nuevo)}
	method cumpleCondiciones(nuevo) = nuevo.tieneDisfraz() && !asistentes.contains(nuevo)
	method inolvidable() = asistentes.all({asist=>asist.sexy() && asist.satisfecho()})
}