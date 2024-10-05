using AutoMapper;
using HelpDeskSystem.Models;
using HelpDeskSystem.ViewModels;

namespace HelpDeskSystem.Services
{
    public class AutoMapperProfileService : Profile
    {
        public AutoMapperProfileService()
        {
            CreateMap<TicketSubCategoriesVM, TicketSubCategory>().ReverseMap();
        }
    }
}
