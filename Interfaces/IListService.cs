using HelpDeskSystem.Models;

namespace HelpDeskSystem.Interfaces
{
    public interface IListService
    {
        Task<List<Reply>> GetRepliesAsync(string userid);
    }
}
