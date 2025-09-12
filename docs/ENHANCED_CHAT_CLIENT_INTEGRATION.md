# Enhanced Chat v2 Client Integration

## Overview

This document outlines the client-side implementation of Enhanced Chat v2 integration in the Nirva Flutter app. The enhanced chat system provides a WhatsApp-style persistent conversation experience with server-side conversation management, context awareness, and advanced features like search and history.

## Key Features Implemented

### 🔄 **Server-Side Conversation Management**
- **Persistent conversations** - Messages stored on server, persist across sessions
- **Simplified client logic** - Client only sends messages, server manages history
- **Automatic synchronization** - History synced from server on app startup
- **No client-side storage** - Chat history retrieved from server on demand

### 🔍 **Conversation Search**
- **Server-side search** - Full-text search across all conversation messages
- **Real-time search** - Integrated into chat UI for immediate results
- **Fallback to local search** - Local search when server unavailable

### 📊 **Conversation History**
- **Paginated history** - Efficient loading of conversation messages
- **Background sync** - Automatic synchronization without blocking UI
- **Persistent across sessions** - Conversations continue where they left off

## Architecture Changes

### API Layer Changes

#### Updated URL Configuration (`lib/url_configuration.dart`)

```dart
class URLConfiguration {
  // Enhanced chat v2 endpoint
  String get chatActionUrl {
    return _urlConfig.endpoints['chat'] ?? ''; // Points to /action/chat/v2/
  }
  
  // New conversation management endpoints
  String get conversationHistoryUrl {
    return _urlConfig.endpoints['conversation_history'] ?? '';
  }
  
  String get conversationStatsUrl {
    return _urlConfig.endpoints['conversation_stats'] ?? '';
  }
  
  String get conversationSearchUrl {
    return _urlConfig.endpoints['conversation_search'] ?? '';
  }
}
```

#### Simplified Chat API (`lib/nirva_api.dart`)

**Key Changes:**
- Removed client-side chat history management
- Server now manages conversation persistence
- Simplified request format

```dart
// Send message to enhanced chat v2 endpoint
Future<ChatActionResponse?> sendChatAction(ChatMessage userMessage) async {
  // Create simplified request - server manages history
  final chatActionRequest = ChatActionRequest(
    human_message: userMessage,
    chat_history: [], // Always empty - server manages this
  );
  
  final response = await _dio.post<Map<String, dynamic>>(
    _urlConfig.chatActionUrl, // Points to /action/chat/v2/
    data: chatActionRequest.toJson(),
  );
  
  // Parse and return AI response
  return ChatActionResponse.fromJson(response.data!);
}
```

#### Conversation History Sync

```dart
// Sync conversation history from server
Future<List<ChatMessage>?> getConversationHistory({
  int limit = 50,
  int offset = 0,
}) async {
  final response = await _dio.get<Map<String, dynamic>>(
    _urlConfig.conversationHistoryUrl,
    queryParameters: {
      'limit': limit,
      'offset': offset,
    },
  );
  
  if (response.data != null) {
    final historyResponse = ConversationHistoryResponse.fromJson(response.data!);
    return historyResponse.messages;
  }
  return null;
}
```

#### Server-Side Search

```dart
// Search messages on server using form data
Future<List<ChatMessage>?> searchConversation(String query, {int limit = 20}) async {
  final response = await _dio.post<Map<String, dynamic>>(
    _urlConfig.conversationSearchUrl,
    data: FormData.fromMap({
      'query': query,
      'limit': limit,
    }),
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  
  if (response.data != null) {
    final searchResponse = ConversationSearchResponse.fromJson(response.data!);
    return searchResponse.messages;
  }
  return null;
}
```

### State Management Changes

#### Updated ChatHistoryProvider (`lib/providers/chat_history_provider.dart`)

**Key Updates:**
- Added server synchronization methods
- Renamed duplicate method to avoid conflicts
- Integrated server-side search functionality

```dart
class ChatHistoryProvider with ChangeNotifier {
  // Sync from server on app startup
  Future<bool> syncFromServer({int limit = 50, int offset = 0}) async {
    try {
      final serverMessages = await _nirvaApi.getConversationHistory(
        limit: limit,
        offset: offset,
      );
      
      if (serverMessages != null && serverMessages.isNotEmpty) {
        // Clear local history and replace with server data
        _chatHistory.clear();
        _chatHistory.addAll(serverMessages);
        notifyListeners();
        return true;
      }
    } catch (e) {
      Logger().e('Failed to sync from server: $e');
    }
    return false;
  }
  
  // Server-side search (primary)
  Future<List<ChatMessage>?> searchMessages(String query) async {
    try {
      return await _nirvaApi.searchConversation(query);
    } catch (e) {
      Logger().e('Server search failed, falling back to local: $e');
      return searchMessagesLocal(query); // Fallback to local search
    }
  }
  
  // Local search (fallback) - renamed to avoid conflicts
  List<ChatMessage> searchMessagesLocal(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _chatHistory.where((message) {
      return message.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
```

### UI Integration

#### Chat Page Integration (`lib/nirva_chat_page.dart`)

**Key Changes:**
- Added server sync on startup
- Fixed MessageRole enum handling
- Preserved existing UI while adding new functionality

```dart
class _NirvaChatPageState extends State<NirvaChatPage> {
  @override
  void initState() {
    super.initState();
    
    // Sync conversation history from server on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatHistoryProvider>().syncFromServer();
    });
  }
  
  // Helper method to convert role integer to string
  String _getRoleName(int role) {
    switch (role) {
      case MessageRole.system:
        return 'System';
      case MessageRole.human:
        return 'Human';
      case MessageRole.ai:
        return 'AI';
      default:
        return 'Unknown';
    }
  }
}
```

## Data Models

### Request Models

```dart
@freezed
class ChatActionRequest with _$ChatActionRequest {
  const factory ChatActionRequest({
    required ChatMessage human_message,
    required List<ChatMessage> chat_history, // Always empty in v2
  }) = _ChatActionRequest;
  
  factory ChatActionRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatActionRequestFromJson(json);
}
```

### Response Models

```dart
@freezed
class ConversationHistoryResponse with _$ConversationHistoryResponse {
  const factory ConversationHistoryResponse({
    required List<ChatMessage> messages,
    required int total_count,
    required int limit,
    required int offset,
    required bool has_more,
  }) = _ConversationHistoryResponse;
  
  factory ConversationHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationHistoryResponseFromJson(json);
}

@freezed
class ConversationSearchResponse with _$ConversationSearchResponse {
  const factory ConversationSearchResponse({
    required List<ChatMessage> messages,
    required String query,
    required int result_count,
  }) = _ConversationSearchResponse;
  
  factory ConversationSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationSearchResponseFromJson(json);
}
```

## Integration Flow

### Message Sending Flow

1. **User Input** - User types message in chat UI
2. **Create Message** - ChatMessage object created with user content
3. **Send to Server** - Message sent to `/action/chat/v2/` endpoint
4. **Server Processing** - Server stores message, builds context, processes with AI
5. **Receive Response** - AI response returned to client
6. **Update UI** - Both user and AI messages displayed in chat

### Conversation History Flow

1. **App Startup** - `syncFromServer()` called in chat page `initState()`
2. **Fetch History** - GET request to `/conversation/history/` endpoint
3. **Update State** - ChatHistoryProvider updated with server messages
4. **Refresh UI** - Chat interface shows conversation history

### Search Flow

1. **User Search** - User enters search query in UI
2. **Server Search** - POST request to `/conversation/search/` with form data
3. **Display Results** - Search results shown in chat interface
4. **Fallback** - Local search used if server unavailable

## Configuration Changes

### URL Configuration Update

Server-side URL configuration updated to support enhanced chat v2:

```python
# nirva_service/src/nirva_service/services/app_services/url_config.py
"chat": base + "action/chat/v2/",  # Changed from v1 to v2
"conversation_history": base + "conversation/history/",  # New
"conversation_stats": base + "conversation/stats/",      # New
"conversation_search": base + "conversation/search/",    # New
```

## Error Handling

### Network Error Handling

```dart
try {
  final response = await _nirvaApi.sendChatAction(userMessage);
  // Handle successful response
} catch (e) {
  if (e is DioException) {
    if (e.response?.statusCode == 500) {
      // Server error - show user-friendly message
      _showErrorMessage('Server is experiencing issues. Please try again.');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      // Connection timeout
      _showErrorMessage('Connection timeout. Please check your internet.');
    }
  }
  Logger().e('Chat error: $e');
}
```

### Search Error Handling

```dart
Future<List<ChatMessage>?> searchMessages(String query) async {
  try {
    // Try server search first
    return await _nirvaApi.searchConversation(query);
  } catch (e) {
    Logger().e('Server search failed, falling back to local: $e');
    // Fallback to local search
    return searchMessagesLocal(query);
  }
}
```

## Performance Considerations

### Efficient History Loading

- **Pagination** - Load history in chunks (50 messages at a time)
- **Background sync** - History synced without blocking UI
- **Caching** - Local state maintained for smooth scrolling

### Memory Management

- **Limited local storage** - Only recent messages kept in memory
- **On-demand loading** - Older messages loaded when needed
- **Automatic cleanup** - Old messages cleaned up periodically

## Testing Integration

### Manual Testing Workflow

1. **Login** - Use test credentials (username: yytestbot, password: test123)
2. **Send Message** - Verify message sent to enhanced chat v2 endpoint
3. **Check Persistence** - Close and reopen app, verify conversation history
4. **Test Search** - Search for previous messages
5. **Context Awareness** - Verify AI responses include context awareness

### API Testing Commands

```bash
# Test conversation history
curl -X GET "http://localhost:8000/conversation/history/?limit=10" \
  -H "Authorization: Bearer $TOKEN"

# Test conversation search  
curl -X POST "http://localhost:8000/conversation/search/" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "query=hello&limit=5"
```

## Migration Notes

### From Chat v1 to Enhanced Chat v2

| Aspect | Chat v1 | Enhanced Chat v2 |
|--------|---------|------------------|
| **History Management** | Client-side | Server-side |
| **Conversation Storage** | Local only | Persistent database |
| **Context Awareness** | Basic prompts | Rich context snapshots |
| **Search** | Local only | Server-side full-text |
| **Performance** | Memory intensive | Efficient pagination |
| **Offline Support** | Full offline | Online-first with fallback |

### Breaking Changes

1. **API Endpoint** - Changed from `/action/chat/v1/` to `/action/chat/v2/`
2. **Request Format** - `chat_history` array always empty
3. **Response Handling** - Server manages conversation state
4. **Search Method** - Server search primary, local search fallback

## Future Enhancements

### Planned Features
- **Offline message queue** - Queue messages when offline, sync when online
- **Message reactions** - Like/dislike functionality for messages
- **Conversation export** - Export conversation history to various formats
- **Voice messages** - Integration with audio processing pipeline
- **Message attachments** - Support for images and files

### Performance Optimizations
- **Message virtualization** - Efficient rendering of large conversation history
- **Incremental sync** - Only sync new messages since last update
- **Background prefetch** - Preload conversation context for faster responses
- **Compression** - Compress large message payloads for better network performance

## Troubleshooting

### Common Issues

1. **500 Server Error** - Check database tables exist on server
2. **Authentication Failure** - Verify token is valid and not expired
3. **Search Not Working** - Ensure form data format for search endpoint
4. **History Not Syncing** - Check network connection and server status
5. **Duplicate Method Error** - Ensure no conflicting method names

### Debug Commands

```bash
# Check server logs
pm2 logs appservice

# Test API endpoints
curl -X GET "http://localhost:8000/health/"

# Check database connection
psql -U fastapi_user -d my_fastapi_db -c "SELECT COUNT(*) FROM conversation_messages;"
```