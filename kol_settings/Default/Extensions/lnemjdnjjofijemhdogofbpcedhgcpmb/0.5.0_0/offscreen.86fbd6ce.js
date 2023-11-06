const textarea = document.querySelector("textarea");

chrome.runtime.onMessage.addListener(((e, t, a) => {
  if ("offscreen-doc" === e.target) {
    switch (e.type) {
     case "copy-to-clipboard":
      textarea.value = e.text, textarea.select(), document.execCommand("copy");
      break;

     case "read-clipboard":
      return textarea.select(), document.execCommand("paste"), a(textarea.value), !0;
    }
    return !1;
  }
}));
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJtYXBwaW5ncyI6IkFBYUEsTUFBTUEsV0FBV0MsU0FBU0MsY0FBYzs7QUFFeENDLE9BQU9DLFFBQVFDLFVBQVVDLGFBQ3hCLENBQUNDLEdBQTJCQyxHQUFHQztFQUM5QixJQUF1QixvQkFBbkJGLEVBQVFHLFFBQVo7SUFFQSxRQUFRSCxFQUFRSTtLQUNmLEtBQUs7TUFDSlgsU0FBU1ksUUFBUUwsRUFBUU0sTUFDekJiLFNBQVNjLFVBQ1RiLFNBQVNjLFlBQVk7TUFDckI7O0tBRUQsS0FBSztNQUlKLE9BSEFmLFNBQVNjLFVBQ1RiLFNBQVNjLFlBQVksVUFDckJOLEVBQWFULFNBQVNZLFNBQ2Y7O0lBTVQsUUFBTztBQW5CaUM7QUFtQjVCIiwic291cmNlcyI6WyJzcmMvYmFja2dyb3VuZC91dGlscy9vZmZzY3JlZW4udHMiXSwic291cmNlc0NvbnRlbnQiOlsiaW50ZXJmYWNlIENvcHlUb0NsaXBib2FyZE1lc3NhZ2Uge1xuXHR0eXBlOiBcImNvcHktdG8tY2xpcGJvYXJkXCI7XG5cdHRhcmdldDogXCJvZmZzY3JlZW4tZG9jXCI7XG5cdHRleHQ6IHN0cmluZztcbn1cblxuaW50ZXJmYWNlIFJlYWRDbGlwYm9hcmRNZXNzYWdlIHtcblx0dHlwZTogXCJyZWFkLWNsaXBib2FyZFwiO1xuXHR0YXJnZXQ6IFwib2Zmc2NyZWVuLWRvY1wiO1xufVxuXG50eXBlIE9mZnNjcmVlbk1lc3NhZ2UgPSBDb3B5VG9DbGlwYm9hcmRNZXNzYWdlIHwgUmVhZENsaXBib2FyZE1lc3NhZ2U7XG5cbmNvbnN0IHRleHRhcmVhID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcihcInRleHRhcmVhXCIpITtcblxuY2hyb21lLnJ1bnRpbWUub25NZXNzYWdlLmFkZExpc3RlbmVyKFxuXHQobWVzc2FnZTogT2Zmc2NyZWVuTWVzc2FnZSwgXywgc2VuZFJlc3BvbnNlKSA9PiB7XG5cdFx0aWYgKG1lc3NhZ2UudGFyZ2V0ICE9PSBcIm9mZnNjcmVlbi1kb2NcIikgcmV0dXJuO1xuXG5cdFx0c3dpdGNoIChtZXNzYWdlLnR5cGUpIHtcblx0XHRcdGNhc2UgXCJjb3B5LXRvLWNsaXBib2FyZFwiOlxuXHRcdFx0XHR0ZXh0YXJlYS52YWx1ZSA9IG1lc3NhZ2UudGV4dDtcblx0XHRcdFx0dGV4dGFyZWEuc2VsZWN0KCk7XG5cdFx0XHRcdGRvY3VtZW50LmV4ZWNDb21tYW5kKFwiY29weVwiKTtcblx0XHRcdFx0YnJlYWs7XG5cblx0XHRcdGNhc2UgXCJyZWFkLWNsaXBib2FyZFwiOlxuXHRcdFx0XHR0ZXh0YXJlYS5zZWxlY3QoKTtcblx0XHRcdFx0ZG9jdW1lbnQuZXhlY0NvbW1hbmQoXCJwYXN0ZVwiKTtcblx0XHRcdFx0c2VuZFJlc3BvbnNlKHRleHRhcmVhLnZhbHVlKTtcblx0XHRcdFx0cmV0dXJuIHRydWU7XG5cblx0XHRcdGRlZmF1bHQ6XG5cdFx0XHRcdGJyZWFrO1xuXHRcdH1cblxuXHRcdHJldHVybiBmYWxzZTtcblx0fVxuKTtcbiJdLCJuYW1lcyI6WyJ0ZXh0YXJlYSIsImRvY3VtZW50IiwicXVlcnlTZWxlY3RvciIsImNocm9tZSIsInJ1bnRpbWUiLCJvbk1lc3NhZ2UiLCJhZGRMaXN0ZW5lciIsIm1lc3NhZ2UiLCJfIiwic2VuZFJlc3BvbnNlIiwidGFyZ2V0IiwidHlwZSIsInZhbHVlIiwidGV4dCIsInNlbGVjdCIsImV4ZWNDb21tYW5kIl0sInZlcnNpb24iOjMsImZpbGUiOiJvZmZzY3JlZW4uODZmYmQ2Y2UuanMubWFwIn0=
