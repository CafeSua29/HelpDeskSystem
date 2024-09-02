using HelpDeskSystem.Data;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace HelpDeskSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DatasController : Controller
    {
        private readonly ApplicationDbContext _context;

        public DatasController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/<DatasController>
        [HttpGet]
        public JsonResult GetTicketSubCategories(int categoryId)
        {
            try
            {
                var subCategories = _context
                    .TicketSubCategories
                    .Where(x => x.CategoryId == categoryId)
                    .OrderBy(c => c.Name)
                    .Select(i => new { Id = i.Id, Name = i.Name })
                    .ToList();

                return Json(subCategories);
            }
            catch (Exception ex)
            {
                return Json(new { });
            }
        }

        // GET api/<DatasController>/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<DatasController>
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<DatasController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<DatasController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
