<?php

namespace App\Traits;

use Illuminate\Http\JsonResponse;

trait ApiResponse
{
    /**
     * Send a standard success response.
     */
    protected function successResponse($data = null, string $message = 'Success', int $code = 200): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'message' => $message,
            'data' => $data,
        ], $code);
    }

    /**
     * Send a standard error response.
     */
    protected function errorResponse(string $message, $errors = null, int $code = 400): JsonResponse
    {
        $response = [
            'status' => 'error',
            'message' => $message,
        ];

        if (! empty($errors)) {
            $response['errors'] = $errors;
        }

        return response()->json($response, $code);
    }

    /**
     * Format a paginated Laravel API Resource collection.
     */
    protected function paginatedResponse($resourceCollection, string $message = 'Success'): JsonResponse
    {
        // Extract the resource data and pagination meta data
        $resourceData = $resourceCollection->response()->getData(true);

        return response()->json([
            'status' => 'success',
            'message' => $message,
            'data' => $resourceData['data'],
            'meta' => [
                'current_page' => $resourceData['meta']['current_page'] ?? 1,
                'last_page' => $resourceData['meta']['last_page'] ?? 1,
                'per_page' => $resourceData['meta']['per_page'] ?? 15,
                'total' => $resourceData['meta']['total'] ?? 0,
            ],
        ], 200);
    }
}
