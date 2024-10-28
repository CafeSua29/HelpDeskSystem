using AutoMapper;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Interfaces;
using HelpDeskSystem.Models;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace HelpDeskSystem.Controllers
{
    public class ExcelExportsController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly IExportService _exportService;
        private readonly IMapper _mapper;

        public ExcelExportsController(ApplicationDbContext context, IConfiguration configuration, IExportService exportService, IMapper mapper)
        {
            _context = context;
            _configuration = configuration;
            _exportService = exportService;
            _mapper = mapper;
        }

        public async Task<IActionResult> ExportTickets(string Title, int StatusId, string CreatedById, string AssignedToId, DateTime CreatedOn)
        {
            var cc = new CommentsController(_context);

            var allticket = _context.Tickets
                .Include(c => c.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .Where(t => t.DelTime == null)
                .OrderByDescending(c => c.CreatedOn)
                .AsQueryable();

            if (!string.IsNullOrEmpty(Title))
            {
                allticket = allticket.Where(x => x.Title.Contains(Title) || x.Description.Contains(Title));
            }

            if (StatusId > 0)
            {
                allticket = allticket.Where(x => x.StatusId == StatusId);
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                allticket = allticket.Where(x => x.CreatedById == CreatedById);
            }

            if (!string.IsNullOrEmpty(AssignedToId))
            {
                allticket = allticket.Where(x => x.AssignedToId == AssignedToId);
            }

            DateTime dt = new DateTime();

            if (DateTime.Compare(CreatedOn, dt) > 0)
            {
                allticket = allticket.Where(x => DateOnly.FromDateTime(x.CreatedOn).CompareTo(DateOnly.FromDateTime(CreatedOn)) == 0);
            }

            var data = await allticket.Select(x => new
            {
                Id = x.Id,
                Title = x.Title,
                Description = x.Description,
                CreatedOn = x.CreatedOn,
                CreatedBy = x.CreatedBy.Name,
                Status = x.Status.Description,
                Priority = x.Priority.Description,
                Category = x.SubCategory.Category.Name,
                SubCategory = x.SubCategory.Name,
                Comments = cc.CountComment(x.Id)
            }).ToListAsync();

            return _exportService.ExportToExcel(data, "Ticket List");
        }

        public async Task<IActionResult> ExportComments(int id, string Desc, string CreatedById)
        {
            var comments = _context.Comments
                .Where(x => x.TicketId == id && x.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderByDescending(c => c.CreatedOn)
                .AsQueryable();

            if (!string.IsNullOrEmpty(Desc))
            {
                comments = comments.Where(x => x.Description.Contains(Desc));
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                comments = comments.Where(x => x.CreatedById == CreatedById);
            }

            var data = await comments.Select(x => new
            {
                Id = x.Id,
                Title = x.Ticket.Title,
                Comment = x.Description,
                CreatedOn = x.CreatedOn,
                CreatedBy = x.CreatedBy.Name
            }).ToListAsync();

            return _exportService.ExportToExcel(data, "Comment List");
        }
    }
}
