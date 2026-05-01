<?php

namespace App\Http\Controllers\Api\Patient;

use App\Http\Controllers\Api\ApiController;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Ghost notifications controller.
 *
 * The notifications table does not exist yet. This controller returns
 * a valid, empty PaginatedResponse so the Flutter app does not throw
 * 404 runtime errors. Replace the body of each method once the
 * notifications feature is built.
 */
class PatientNotificationApiController extends ApiController
{
    /**
     * GET /patient/notifications
     * Returns an empty paginated list.
     */
    public function index(Request $request): JsonResponse
    {
        return response()->json([
            'status'  => 'success',
            'message' => 'Notifications loaded.',
            'data'    => [],
            'meta'    => [
                'current_page' => 1,
                'last_page'    => 1,
                'per_page'     => (int) $request->get('per_page', 20),
                'total'        => 0,
            ],
        ]);
    }

    /**
     * PATCH /patient/notifications/{id}/read
     * No-op until the notifications table exists.
     */
    public function markAsRead(Request $request, string $id): JsonResponse
    {
        return $this->errorResponse('Notifications are not yet available.', null, 404);
    }
}
