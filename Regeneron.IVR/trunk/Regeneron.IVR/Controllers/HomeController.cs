using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Net.Http;
using Newtonsoft.Json;
using System.Text;

namespace Regeneron.IVR.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            RequestViewModel vm = new RequestViewModel();
            return View(vm);
        }

        public ActionResult Save(RequestViewModel vm)
        {
            TempData["error"] = ValidateForm(vm);
            TempData["success"] = null;
            
            if (TempData["error"] == null)
            {
                // save to DB
                DataAccess.Save(vm);

                if (vm.SendViaEmail)
                    SendEmail(vm);

                TempData["success"] = "Request submitted successfully!";
                vm = new RequestViewModel();
                ModelState.Clear();
            }

            return View("Index", vm);
        }

        private void SendEmail(RequestViewModel vm)
        {
            string contactId;

            try
            {
                // first do the lookup
                dynamic contact = LookupEloquaContact(vm.Email);
                contactId = contact.elements[0].id;
            }
            catch (Exception)
            {
                // contact not found, create it
                dynamic contact = CreateEloquaContact(vm.Email, vm.FirstName, vm.LastName);
                contactId = contact.id;
            }

            EmailEloquaContact(contactId);

        }

        private dynamic LookupEloquaContact(string email)
        {
            using(var client = new HttpClient())
            {
                string url = App.EmailSvcUrl + "1.0/data/contacts";

                string authCode = Convert.ToBase64String(Encoding.UTF8.GetBytes(App.EmailSvcUser+ ":" + App.EmailSvcPassword));
                client.DefaultRequestHeaders.Add("Authorization", "Basic " + authCode);
                client.BaseAddress = new Uri(url);

                var result = client.GetAsync(url + "?search=\"emailAddress=" + email + "\"").Result;

                string responseString = result.Content.ReadAsStringAsync().Result;

                dynamic jsonResponse = JsonConvert.DeserializeObject(responseString);

                if (result.StatusCode != System.Net.HttpStatusCode.OK)
                {
                    throw new Exception("Failed to search for contact. Response: " + ((int)result.StatusCode).ToString());
                }

                return jsonResponse;
            };
        }

        private dynamic CreateEloquaContact(string email, string firstName, string lastName)
        {
            using (var client = new HttpClient())
            {
                string url = App.EmailSvcUrl + "1.0/data/contact";

                string authCode = Convert.ToBase64String(Encoding.UTF8.GetBytes(App.EmailSvcUser + ":" + App.EmailSvcPassword));
                client.DefaultRequestHeaders.Add("Authorization", "Basic " + authCode);
                client.BaseAddress = new Uri(url);

                string payload = "{ \"emailAddress\": \"" + email + "\", ";
                payload += "\"firstName\": \"" + firstName + "\", ";
                payload += "\"lastName\": \"" + lastName + "\", ";
                payload += "\"depth\": \"minimal\" }";

                var result = client.PostAsync(url, new StringContent(payload, Encoding.UTF8, "application/json")).Result;

                string responseString = result.Content.ReadAsStringAsync().Result;

                dynamic jsonResponse = JsonConvert.DeserializeObject(responseString);

                if (result.StatusCode != System.Net.HttpStatusCode.Created)
                {
                    throw new Exception("Failed to create contact. Response: " + ((int)result.StatusCode).ToString());
                }

                return jsonResponse;
            };
        }

        private dynamic EmailEloquaContact(string contactId)
        {
            using (var client = new HttpClient())
            {
                string url = App.EmailSvcUrl + "2.0/assets/email/deployment";

                string authCode = Convert.ToBase64String(Encoding.UTF8.GetBytes(App.EmailSvcUser + ":" + App.EmailSvcPassword));
                client.DefaultRequestHeaders.Add("Authorization", "Basic " + authCode);
                client.BaseAddress = new Uri(url);

                string payload = "{ \"type\": \"EmailLowVolumeDeployment\", ";
                payload += "\"name\": \"" + App.EmailName + "\", ";
                payload += "\"contactIds\": [\"" + contactId + "\"], ";
                payload += "\"email\": {\"id\": \"" + App.EmailId + "\", \"name\": \"" + App.EmailName + "\" }, ";
                payload += "\"sendFromUserId\": \"" + App.EmailSendFromUserId + "\", ";
                payload += "\"sendOptions\": {\"allowResend\": \"true\", \"allowSendToUnsubscribe\": \"true\" } ";
                payload += "}";

                var result = client.PostAsync(url, new StringContent(payload, Encoding.UTF8, "application/json")).Result;

                string responseString = result.Content.ReadAsStringAsync().Result;

                dynamic jsonResponse = JsonConvert.DeserializeObject(responseString);

                if (result.StatusCode != System.Net.HttpStatusCode.Created)
                {
                    throw new Exception("Failed to send email. Response: " + ((int)result.StatusCode).ToString());
                }

                return jsonResponse;
            };
        }

        private string ValidateForm(RequestViewModel vm)
        {
            if (string.IsNullOrWhiteSpace(vm.FirstName))
                return "Please enter first name";

            if (string.IsNullOrWhiteSpace(vm.LastName))
                return "Please enter last name";

            if (!vm.SendViaEmail && !vm.SendViaMail)
                return "Please select a delivery method";

            if (vm.Quantity <= 0 || vm.Quantity > 5)
                return "Please enter a valid quantity (1-5)";

            if (vm.SendViaEmail && !IsValidEmail(vm.Email))
                return "Please enter a valid email address";

            if (vm.SendViaMail)
            {
                if (string.IsNullOrWhiteSpace(vm.Address1))
                    return "Please enter address 1";
                if (string.IsNullOrWhiteSpace(vm.City))
                    return "Please enter city";
                if (string.IsNullOrWhiteSpace(vm.State))
                    return "Please select state";
                if (string.IsNullOrWhiteSpace(vm.Zip))
                    return "Please enter zip";
                else
                {
                    string zip = vm.Zip.Replace("-", "");
                    long z = 0;
                    if (!long.TryParse(zip, out z))
                        return "Please enter a valid zip";
                }
            }

            return null;
        }

        private static bool IsValidEmail(string emailaddress)
        {
            try
            {
                System.Net.Mail.MailAddress m = new System.Net.Mail.MailAddress(emailaddress);

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }

    

    public class RequestViewModel
    {
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public int Quantity { get; set; }
        public bool SendViaEmail { get; set; }
        public bool SendViaMail { get; set; }

        public List<SelectListItem> StateSelectionOptions { get; set; }

        public RequestViewModel()
        {
            Quantity = 1;

            StateSelectionOptions = new List<SelectListItem>()
            {
                new SelectListItem() { Text = "Select State", Value = "" },
                new SelectListItem() { Text = "Alabama", Value = "AL" },
                new SelectListItem() { Text = "Alaska", Value = "AK" },
                new SelectListItem() { Text = "Arizona", Value = "AZ" },
                new SelectListItem() { Text = "Arkansas", Value = "AR" },
                new SelectListItem() { Text = "California", Value = "CA" },
                new SelectListItem() { Text = "Colorado", Value = "CO" },
                new SelectListItem() { Text = "Connecticut", Value = "CT" },
                new SelectListItem() { Text = "Delaware", Value = "DE" },
                new SelectListItem() { Text = "District of Columbia", Value = "DC" },
                new SelectListItem() { Text = "Florida", Value = "FL" },
                new SelectListItem() { Text = "Georgia", Value = "GA" },
                new SelectListItem() { Text = "Hawaii", Value = "HI" },
                new SelectListItem() { Text = "Idaho", Value = "ID" },
                new SelectListItem() { Text = "Illinois", Value = "IL" },
                new SelectListItem() { Text = "Indiana", Value = "IN" },
                new SelectListItem() { Text = "Iowa", Value = "IA" },
                new SelectListItem() { Text = "Kansas", Value = "KS" },
                new SelectListItem() { Text = "Kentucky", Value = "KY" },
                new SelectListItem() { Text = "Louisiana", Value = "LA" },
                new SelectListItem() { Text = "Maine", Value = "ME" },
                new SelectListItem() { Text = "Maryland", Value = "MD" },
                new SelectListItem() { Text = "Massachusetts", Value = "MA" },
                new SelectListItem() { Text = "Michigan", Value = "MI" },
                new SelectListItem() { Text = "Minnesota", Value = "MN" },
                new SelectListItem() { Text = "Mississippi", Value = "MS" },
                new SelectListItem() { Text = "Missouri", Value = "MO" },
                new SelectListItem() { Text = "Montana", Value = "MT" },
                new SelectListItem() { Text = "Nebraska", Value = "NE" },
                new SelectListItem() { Text = "Nevada", Value = "NV" },
                new SelectListItem() { Text = "New Hampshire", Value = "NH" },
                new SelectListItem() { Text = "New Jersey", Value = "NJ" },
                new SelectListItem() { Text = "New Mexico", Value = "NM" },
                new SelectListItem() { Text = "New York", Value = "NY" },
                new SelectListItem() { Text = "North Carolina", Value = "NC" },
                new SelectListItem() { Text = "North Dakota", Value = "ND" },
                new SelectListItem() { Text = "Ohio", Value = "OH" },
                new SelectListItem() { Text = "Oklahoma", Value = "OK" },
                new SelectListItem() { Text = "Oregon", Value = "OR" },
                new SelectListItem() { Text = "Pennsylvania", Value = "PA" },
                new SelectListItem() { Text = "Puerto Rico", Value = "PR" },
                new SelectListItem() { Text = "Rhode Island", Value = "RI" },
                new SelectListItem() { Text = "South Carolina", Value = "SC" },
                new SelectListItem() { Text = "South Dakota", Value = "SD" },
                new SelectListItem() { Text = "Tennessee", Value = "TN" },
                new SelectListItem() { Text = "Texas", Value = "TX" },
                new SelectListItem() { Text = "Utah", Value = "UT" },
                new SelectListItem() { Text = "Vermont", Value = "VT" },
                new SelectListItem() { Text = "Virginia", Value = "VA" },
                new SelectListItem() { Text = "Washington", Value = "WA" },
                new SelectListItem() { Text = "West Virginia", Value = "WV" },
                new SelectListItem() { Text = "Wisconsin", Value = "WI" },
                new SelectListItem() { Text = "Wyoming", Value = "WY" }
        };
    }
    }
}