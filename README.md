# GitHub Repository Search App

## Environment Requirements

| Requirement               | Supported Versions |
| ------------------------- | ------------------ |
| Swift                     | Swift 5+           |
| Minimum Deployment Target | iOS 13+            |

## Feature Description

### 1. Search Functionality
- Using GitHub API's `search/repositories` endpoint for repository search.
- Search Bar includes a clear button.
- Clear button removes both Search Bar text and search results.

### 2. Search Results List
- List displays information:
  - Owner icon
  - Name
  - Description
- Tapping list item navigates to detailed view.
- Pull-to-refresh functionality:
  - Pull to top to trigger search
  - Displays warning message if seach text is empty
- Dynamic Navigation Bar style adaptation.

### 3. Repository Details Page
- Displays repository information:
  - Repository name
  - Owner icon
  - Primary programming language
  - Number of Stars
  - Number of Watchers
  - Number of Forks
  - Number of Issues
- Provides "< Back" button to return to list view.

## API Reference
- API Documentation:
  [GitHub Search Repositories API](https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#search-repositories)

## Screenshot

![Screenshot](Screenshot.gif)