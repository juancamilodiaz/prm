package controllers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type MainController struct {
	beego.Controller
}

/*Index*/
func (c *MainController) Get() {
	c.Data["Website"] = "beego.me"
	c.Data["Email"] = "astaxie@gmail.com"
	c.TplName = "index2.tpl"
}

/* Resources * /
func (main *MainController) ListResources() {
	url := "http://localhost:10104/GetResources"

	payload := strings.NewReader("{\n\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Resources", message.Resources)
		main.Data["Resources"] = message.Resources
		main.TplName = "Resources/listResources.tpl"
	} else {
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) CreateResource() {
	url := "http://localhost:10104/CreateResource"

	payload := strings.NewReader("{" +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"," +
		"\n\t\"LastName\":\"" + main.GetString("LastName") + "\"," +
		"\n\t\"Email\":\"" + main.GetString("Email") + "\"," +
		"\n\t\"Photo\":\"" + main.GetString("Photo") + "\"," +
		"\n\t\"EngineerRange\":\"" + main.GetString("EngineerRange") + "\"," +
		"\n\t\"Enabled\":" + main.GetString("Enabled") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.GetResourcesRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
}

func (main *MainController) ReadResource() {
	url := "http://localhost:10104/GetResources"

	payload := strings.NewReader("{\n\t\"Id\":" + main.Ctx.Input.Param(":id") + "\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")
	req.Header.Add("postman-token", "4912b41c-8142-84c6-61b3-a6d2d8d3daec")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		fmt.Println("Respuesta", res)
		defer res.Body.Close()
		message := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&message)

		main.Data["Resources"] = message.Resources
		main.TplName = "Resources/viewResources.tpl"
	} else {
		log.Error(err.Error())
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) UpdateResource() {
	url := "http://localhost:10104/UpdateResource"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") + "," +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"," +
		"\n\t\"LastName\":\"" + main.GetString("LastName") + "\"," +
		"\n\t\"Email\":\"" + main.GetString("Email") + "\"," +
		"\n\t\"Photo\":\"" + main.GetString("Photo") + "\"," +
		"\n\t\"EngineerRange\":\"" + main.GetString("EngineerRange") + "\"," +
		"\n\t\"Enabled\":" + main.GetString("Enabled") + "\n}")

	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}
	message := new(domain.UpdateResourceRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
}

func (main *MainController) DeleteResource() {
	url := "http://localhost:10104/DeleteResource"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.GetResourcesRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
}
*/

/* Projects * /
func (main *MainController) ListProjects() {
	url := "http://localhost:10104/GetProjects"

	payload := strings.NewReader("{\n\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Projects", message.Projects)
		main.Data["Projects"] = message.Projects
		main.TplName = "Projects/listProjects.tpl"
	} else {
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) CreateProject() {
	url := "http://localhost:10104/CreateProject"

	payload := strings.NewReader("{" +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"," +
		"\n\t\"StartDate\":\"" + main.GetString("StartDate") + "\"," +
		"\n\t\"EndDate\":\"" + main.GetString("EndDate") + "\"," +
		"\n\t\"Enabled\":" + main.GetString("Enabled") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	defer res.Body.Close()
	message := new(domain.CreateProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	if err != nil {
		log.Error(err.Error())
	}
}

func (main *MainController) ReadProject() {
	url := "http://localhost:10104/GetProjects"

	payload := strings.NewReader("{\n\t\"Id\":" + main.Ctx.Input.Param(":id") + "\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")
	req.Header.Add("postman-token", "4912b41c-8142-84c6-61b3-a6d2d8d3daec")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		fmt.Println("Respuesta", res)
		defer res.Body.Close()
		message := new(domain.GetProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)

		main.Data["Projects"] = message.Projects
		main.TplName = "Projects/viewProjects.tpl"
	} else {
		log.Error(err.Error())
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) UpdateProject() {
	url := "http://localhost:10104/UpdateProject"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") + "," +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"," +
		"\n\t\"StartDate\":\"" + main.GetString("StartDate") + "\"," +
		"\n\t\"EndDate\":\"" + main.GetString("EndDate") + "\"," +
		"\n\t\"Enabled\":" + main.GetString("Enabled") + "\n}")

	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	defer res.Body.Close()
	message := new(domain.UpdateProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	if err != nil {
		log.Error(err.Error())
	}
}

func (main *MainController) DeleteProject() {
	url := "http://localhost:10104/DeleteProject"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.DeleteProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	main.Data["Title"] = "The project deleted successfully."
	main.Data["Message"] = message.Message
	main.Data["Type"] = message.Status
	main.TplName = "Common/message.tpl"
}

/* Skills * /
func (main *MainController) ListSkills() {
	url := "http://localhost:10104/GetSkills"

	payload := strings.NewReader("{\n\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetSkillsRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Skills", message.Skills)
		main.Data["Skills"] = message.Skills
		main.TplName = "Skills/listSkills.tpl"
	} else {
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) CreateSkill() {
	url := "http://localhost:10104/CreateSkill"

	payload := strings.NewReader("{" +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"" +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.GetSkillsRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
}

func (main *MainController) ReadSkill() {
	url := "http://localhost:10104/GetSkills"

	payload := strings.NewReader("{\n\t\"Id\":" + main.Ctx.Input.Param(":id") + "\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")
	req.Header.Add("postman-token", "4912b41c-8142-84c6-61b3-a6d2d8d3daec")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		fmt.Println("Respuesta", res)
		defer res.Body.Close()
		message := new(domain.GetSkillsRS)
		json.NewDecoder(res.Body).Decode(&message)

		main.Data["Skills"] = message.Skills
		main.TplName = "Skills/viewSkills.tpl"
	} else {
		log.Error(err.Error())
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) UpdateSkill() {
	url := "http://localhost:10104/UpdateSkill"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") + "," +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"" + "\n}")

	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	defer res.Body.Close()
	message := new(domain.UpdateSkillRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	if err != nil {
		log.Error(err.Error())
	}

}

func (main *MainController) DeleteSkill() {
	url := "http://localhost:10104/DeleteSkill"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.GetSkillsRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
}
*/
