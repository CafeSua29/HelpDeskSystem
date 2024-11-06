using DinkToPdf;
using HelpDeskSystem.ViewModels;
using Microsoft.AspNetCore.Mvc;

namespace HelpDeskSystem.Interfaces
{
    public interface IExportService
    {
        Task<byte[]> ExportToPdf(string url, string reportTitle, string paperKind="A3", Orientation or = Orientation.Portrait);

        Task<byte[]> ExportPageToPdf<T>(ReportGenerationVM<T> model);

        //FileStreamResult ExportToExcel(List<string> header, IEnumerable<object> data, string filename);

        FileStreamResult ExportToExcel<T>(List<string> header, List<T> data, string filename);
    }
}
