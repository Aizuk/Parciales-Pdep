class Grupo{
	var limiteIntegrantes
	var integrantes = []
	constructor(_limiteIntegrantes,_integrantes){
		limiteIntegrantes = _limiteIntegrantes
	}
	method cantidadIntegrantes() = integrantes.size()
	method hayEspacio() = self.cantidadIntegrantes()<limiteIntegrantes
	method puedeEntrar(uniformado) = self.hayEspacio() && uniformado.esExperimentado()
	method entrarUniformado(uniformado) {
		if (self.puedeEntrar(uniformado)){
			integrantes.add(uniformado)
			uniformado.entrarGrupo(self)
		}
	}
	method puedeIntervenir(conflicto) = conflicto.puedeIntervenirse(self)
	method intervenir(conflicto) = conflicto.serIntervenido(self)
	method escarmentar() = integrantes.forEach({integrante=>integrante.serEscarmentado()})
	method sumarExperiencia(hectareas) = integrantes.forEach({integrante=>integrante.sumarExperiencia(hectareas)})
	method sumarAlHistorial(conflicto) = integrantes.forEach({integrante=>integrante.sumarAlHistorial(conflicto)}) 
}

class Uniformado{
	var denuncias
	var habilidades
	var horasEntrenadas
	var grupo = []
	var historialConflictos
	var categoria = pichon
	constructor(_denuncias,_habilidades,_horasEntrenadas,_grupo,_historialConflictos){
		denuncias = _denuncias
		habilidades = _habilidades
		horasEntrenadas = _horasEntrenadas
		historialConflictos = _historialConflictos
	}
	method esExperimentado()
	method denuncias() = denuncias
	method tieneHabilidad(habilidad) = habilidades.contains(habilidad)
	method entrarGrupo(_grupo) {grupo.add(_grupo)}
	method serEscarmentado() {self.serDenunciado()}
	method serDenunciado() = categoria.serDenunciado(self)
	method sumarDenuncias(cantidad) {denuncias = denuncias + cantidad}
	method experienciaDesalojo(hectareas) = hectareas/100
	method sumarExperiencia(hectareas) {horasEntrenadas += self.experienciaDesalojo(hectareas)}
	method sumarAlHistorial(conflicto) {historialConflictos.add(conflicto)}
	method cantidadConflictos() = historialConflictos.size()
	method asignarCategoria(_categoria) {categoria = _categoria}
}

class Escorpion inherits Uniformado{
	override method esExperimentado() = horasEntrenadas>200
	method entrenar(veces) {horasEntrenadas += veces*10}
	override method serEscarmentado() {
		super()
		self.entrenar(2)
	}
	override method sumarExperiencia(hectareas) {
		super(hectareas)
		horasEntrenadas += 1
	} 
}

class Gaviota inherits Uniformado{
	override method esExperimentado() = self.tieneHabilidad("disuasion") && self.tieneHabilidad("patrullajeBosques")
	override method sumarExperiencia(hectareas){
		super(hectareas)
		if(self.experienciaDesalojo(hectareas)) {habilidades.add("desalojo")}
	}
}

class CorteDeRuta{
	var cantidadManifestantes
	constructor (_cantidadManifestantes){
		cantidadManifestantes = _cantidadManifestantes
	}
	
	method puedeIntervenirse(grupo) = grupo.cantidadIntegrantes()>cantidadManifestantes
	method serIntervenido(grupo) {
		if(!(self.puedeIntervenirse(grupo))){
			throw new Exception("No")
		} else {
			cantidadManifestantes = cantidadManifestantes/2
			grupo.escarmentar()
			grupo.sumarAlHistorial(self)
		}
	}
}

class Usurpacion{
	var lugar
	constructor(_lugar){
		lugar = _lugar
	}
	method puedeIntervenirse(_) = lugar.esAmplio()
	method serIntervenido(grupo){
		if(!(self.puedeIntervenirse(grupo))){
			throw new Exception("No")
		} else {
			lugar.reducirOvejas()
			grupo.sumarExperiencia(lugar.hectareas())
			grupo.sumarAlHistorial(self)
		}
	}
}

class UsurpacionPrivado inherits Usurpacion{
	var duenio
	constructor(_lugar,_duenio) = super(_lugar){
		duenio = _duenio
	}
	override method puedeIntervenirse(_) = super(_) && duenio.esAcaudalado()
	override method serIntervenido(grupo) {
		if(!(self.puedeIntervenirse(grupo))){
			throw new Exception("No")
		} else {
			super(self)
			grupo.escarmentar()
		}
	}
}

class Lugar{
	var hectareas
	var ovejas
	constructor(_hectareas,_ovejas){
		hectareas = _hectareas
		ovejas = _ovejas
	}
	method esAmplio() = hectareas > 20000
	method hectareas() = hectareas
	method reducirOvejas() {ovejas *= 0.8}
}

class Duenio{
	var fortuna
	constructor(_fortuna){
		fortuna = _fortuna
	}
	method esAcaudalado() = fortuna > 1000000
}

object chuckNorris{
	method pertenece(uniformado) = uniformado.esExperimentado() && uniformado.cantidadConflictos()>500
	method serDenunciado(uniformado) {}
}

object intergalactico{
	method pertenece(uniformado) = uniformado.esExperimentado()
	method serDenunciado(uniformado) = uniformado.sumarDenuncias(3)
}

object adulto{
	method pertenece(uniformado) = uniformado.cantidadConflictos()>10
	method serDenunciado(uniformado) = uniformado.sumarDenuncias(1)
	
}

object pichon{
	method pertenece(uniformado) = true
	method serDenunciado(uniformado) = uniformado.academia().teniente().serDenunciado()
}
object academia{
	var teniente
	const categorias = [chuckNorris,intergalactico,adulto,pichon]
	method asignarTeniente(_teniente) {teniente = _teniente}
	method categoria(uniformado) = categorias.find({categoria=>categoria.pertenece(uniformado)})
	method categoriaCorrecta(uniformado,categoria) = self.categoria(uniformado) == categoria
	method asignarCategoria(uniformado) = uniformado.asignarCategoria(self.categoria(uniformado))
	method teniente() = teniente
}