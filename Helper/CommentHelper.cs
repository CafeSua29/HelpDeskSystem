using System.Text.RegularExpressions;

namespace HelpDeskSystem.Helper
{
    public static class CommentHelper
    {
        public static string ConvertLinks(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text;

            // Regular expression to match URLs

            string pattern = @"((http[s]?://|www\.)[^\s]+)";
            string replacement = "<a href=\"$1\" target=\"_blank\">$1</a>";
            //string replacement = "<a href=\"$1\" target=\"_blank\">" + (text.Length > 30 ? text.Substring(0, 30) + "..." : text) + "</a>";

            return Regex.Replace(text, pattern, replacement);
        }
    }
}
