package util

import (
	"bytes"
	"errors"
	"math"
	"strconv"
	"strings"
	"time"

	"prm/com.omnicon.prm.service/dao"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

//	"es": "Español",
//	"en": "Inglés",
//	"ca": "Catalán",
//	"de": "Alemán",
//	"it": "Italiano",
//	"nl": "Holandés",
//	"fr": "Francés",
//	"pt": "Portugués",
//	"ru": "Ruso",
//	"sv": "Sueco",
//	"zh": "Chino",
//	"ja": "Japonés",
//	"da": "Danés",
//	"ar": "Árabe",
//	"id": "Indonesio",
//	"ko": "Coreano",
//	"ms": "Malayo",
//	"no": "Noruego",
//	"tl": "Tagalo",
//	"th": "Tailandés",
//	"tr": "Turco",
//	"vi": "Vietnamita",

const (
	LANGUAGECODE = "es"
	LANGUAGES    = "es,en,ca,de,it,nl,fr,pt,ru,sv,zh,ja,da,ar,id,ko,ms,no,tl,th,tr,vi"
)

func StringToBool(pString string) bool {
	if pString == "true" {
		return true
	}
	return false
}

// Concadena los string enviados en un solo string
func Concatenar(pCadenas ...string) string {
	listCadenas := bytes.Buffer{}
	for _, cadena := range pCadenas {
		listCadenas.WriteString(cadena)
	}
	return listCadenas.String()
}

// Convierte un entero a string
func IntToString(pNumero int) string {
	return strconv.Itoa(pNumero)
}

// Convierte un entero a string
func Int64ToString(pNumero int64) string {
	return strconv.FormatInt(pNumero, 10)
}

/**
* Funcion engargada de obtener la descripcion necesaria de acuerdo al idioma.
 */
func LenguageManagement(pListLanguages, pLanguage string) string {
	if pListLanguages != "" && pLanguage != "" {
		var descripcion string
		// Separamos la lista para obtener cada pareja de lenguaje y valor asociado
		lenguajes := strings.Split(pListLanguages, "¬")
		for _, leng := range lenguajes {
			// Se descompone cada pareja, primera posicion es el lenguaje
			// La segunda posicion corresponde al valor asociado.
			lengDesc := strings.Split(leng, "|")
			if pLanguage == lengDesc[0] {
				// Retornamos el nombre que nos interesa segun el idioma de la peticion
				descripcion = lengDesc[1]
			}
		}
		if descripcion == "" {
			if pLanguage != "es" {
				for _, leng := range lenguajes {
					lengDesc := strings.Split(leng, "|")
					if lengDesc[0] == "es" {
						// Agregamos la descripcion en español
						descripcion = lengDesc[1]
					}
				}
			}
			if descripcion == "" {
				if pLanguage != "en" {
					for _, leng := range lenguajes {
						lengDesc := strings.Split(leng, "|")
						if lengDesc[0] == "en" {
							// Agregamos la descripcion en ingles
							descripcion = lengDesc[1]
						}
					}
				}
			}
		}
		return descripcion
	}
	log.Debug("No se encontro el idioma %v en el listado %v", pLanguage, pListLanguages)
	return ""
}

// Funcion encargada de convertir un string a entero, en caso de que el valor no sea un numero informa del error
// Sin embargo retorna cero
func StringToInt(pString string) int {
	if pString != "" {
		number, err := strconv.Atoi(pString)
		if err != nil {
			log.Errorf("Ocurrio un error al convertir el valor %v a entero, se retorna cero (0)", pString)
			return 0
		}
		return number
	}
	return 0
}

// GetNumAdultNinBebByOcup Obtiene el número de adultos, niños y bebes; a partir de un código de ocupación.
func GetNumAdultNinBebByOcup(pCodigo string) (a, n, b int, err error) {
	ocupacionSplit := strings.Split(pCodigo, "-")
	if len(ocupacionSplit) == 3 {
		a, err = strconv.Atoi(ocupacionSplit[0])
		if err != nil {
			log.Error("Ocurrio un error obteniendo la cantidad de adultos de la ocupación:", pCodigo)
		}
		n, err = strconv.Atoi(ocupacionSplit[1])
		if err != nil {
			log.Error("Ocurrio un error obteniendo la cantidad de ninos de la ocupación:", pCodigo)
		}
		b, err = strconv.Atoi(ocupacionSplit[2])
		if err != nil {
			log.Error("Ocurrio un error obteniendo la cantidad de bebes de la ocupación:", pCodigo)
		}
	} else {
		log.Error("El código de la ocupación no tiene el formato A-N-B, sino", pCodigo)
		err = errors.New("No se obtiene la cantidad de valores esperados")
	}
	return a, n, b, err
}

// Reemplazamos los saltos de linea por BR
func SaltosToBr(pCadena string) string {
	return strings.Replace(pCadena, "\n", "<br/>", -1)
}

/**
 * Funcion encargada de transformar una lista de string en una lista de int
 */
func SliceStringToInt(pSlice []string) []int {
	if pSlice == nil || len(pSlice) == 0 {
		log.Debug("Lista nil o vacia")
		return []int{}
	}
	var resultList []int
	// Se recorre la lista de strings
	for _, ele := range pSlice {
		eleInt, err := strconv.Atoi(ele)
		if err != nil {
			log.Debug("No se puede convertir la lista de strings")
			return []int{}
		}
		resultList = append(resultList, eleInt)
	}
	return resultList
}

func RedondearFloat64(val float64, places int) (newVal float64) {
	// Valor sumado para mejorar redondeo
	var aux = 0.00000000000001
	val = val + aux
	var roundOn float64
	roundOn = 0.5
	esNegativo := false
	if val < 0 {
		esNegativo = true
		val = val * (-1)
	}
	var round float64
	pow := math.Pow(10, float64(places))
	digit := pow * val
	_, div := math.Modf(digit)
	if div >= roundOn {
		round = math.Ceil(digit)
	} else {
		round = math.Floor(digit)
	}
	newVal = round / pow
	if esNegativo {
		newVal = newVal * (-1)
	}
	return
}

func RedondearFiltros(pValor float64, pDecimales int) float64 {
	valor := strconv.FormatFloat(pValor, 'f', pDecimales, 64)
	valorRedondeado, _ := strconv.ParseFloat(valor, 64)
	return valorRedondeado
}

// Funcion encargada de convertir un string t o f a booleano de go
func BoolPSQLToBool(pString string) bool {
	if pString == "t" {
		return true
	}
	return false
}

/**
* Function to mapping create resource request to business entity resource.
 */
func MappingCreateResource(pRequest *domain.CreateResourceRQ) *domain.Resource {
	resource := new(domain.Resource)
	resource.Name = pRequest.Name
	resource.LastName = pRequest.LastName
	resource.Email = pRequest.Email
	resource.Photo = pRequest.Photo
	resource.EngineerRange = pRequest.EngineerRange
	resource.Enabled = pRequest.Enable

	return resource
}

/**
* Function to mapping create project request to business entity project.
 */
func MappingCreateProject(pRequest *domain.CreateProjectRQ) *domain.Project {
	project := new(domain.Project)
	project.Name = pRequest.Name
	startDate := new(string)
	startDate = &pRequest.StartDate
	endDate := new(string)
	endDate = &pRequest.EndDate
	if startDate == nil || endDate == nil || *startDate == "" || *endDate == "" {
		log.Error("Dates undefined")
		return nil
	}
	startDateInt, endDateInt, err := ConvertirFechasPeticion(startDate, endDate)
	if err != nil {
		log.Error(err)
		return nil
	}
	project.StartDate = time.Unix(startDateInt, 0)
	project.EndDate = time.Unix(endDateInt, 0)
	project.Enabled = pRequest.Enable

	return project
}

/**
* Function to mapping create skill request to business entity project.
 */
func MappingCreateSkill(pRequest *domain.CreateSkillRQ) *domain.Skill {
	skill := new(domain.Skill)
	skill.Name = pRequest.Name
	return skill
}

/**
* Function to mapping skills in a resource entity.
 */
func MappingSkillsInAResource(pResource *domain.Resource, pSkills []*domain.ResourceSkills) {
	mapSkills := make(map[string]int, len(pSkills))
	for _, resourceSkill := range pSkills {
		mapSkills[resourceSkill.Name] = resourceSkill.Value
	}
	pResource.Skills = mapSkills
}

/**
* Function to mapping resources in a project entity.
 */
func MappingResourcesInAProject(pProject *domain.Project, pProjectResources []*domain.ProjectResources) {
	mapResources := make(map[int64]*domain.ResourceAssign, len(pProjectResources))
	for _, projectResource := range pProjectResources {
		resourceAssign := domain.ResourceAssign{}
		resourceAssign.Resource = dao.GetResourceById(projectResource.ResourceId)
		skills := dao.GetResourceSkillsByResourceId(projectResource.ResourceId)
		MappingSkillsInAResource(resourceAssign.Resource, skills)
		resourceAssign.StartDate = projectResource.StartDate
		resourceAssign.EndDate = projectResource.EndDate
		resourceAssign.Lead = projectResource.Lead
		mapResources[projectResource.ID] = &resourceAssign
	}
	pProject.ResourceAssign = mapResources
}
