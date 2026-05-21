import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_call_controller.dart';

class UserCallPage extends GetView<UserCallController> {
  const UserCallPage({super.key});

  // ── Palette & Assets ────────────────────────────────────────────────────────
  static const Color _primary = Color(0xFF2046E8);
  static const Color _red = Color(0xFFEF4444);
  static const Color _bgDark = Color(0xFF0F172A); // Slate 900 for dark call background
  static const Color _bgSlate800 = Color(0xFF1E293B);

  // High-quality premium images for mock video feeds
  static const String _alexRiveraCallImage =
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=800'; // Full screen video
  static const String _userSelfieImage =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300'; // Floating self window

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: Obx(() {
        final isVideo = controller.isVideo.value;
        return Stack(
          children: [
            // ── 1. Background Content ──────────────────────────────────────────
            Positioned.fill(
              child: isVideo ? _buildVideoBackground() : _buildAudioBackground(),
            ),

            // ── 2. Top Header Overlay (Back Button + Call Info) ─────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: _buildHeader(context),
            ),

            // ── 3. Floating Inset Window (Self Video/Avatar) ────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              right: 16,
              child: _buildFloatingInset(),
            ),

            // ── 4. Bottom Control Bar ──────────────────────────────────────────
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 20,
              right: 20,
              child: _buildControlsPanel(),
            ),
          ],
        );
      }),
    );
  }

  // ── Video Call Full-screen Background ───────────────────────────────────────
  Widget _buildVideoBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            _alexRiveraCallImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildAudioBackground(),
          ),
        ),
        // Subtle dark overlays to ensure controls and header text are legible
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Audio Call Center Avatar Background ─────────────────────────────────────
  Widget _buildAudioBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [_bgSlate800, _bgDark],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Avatar
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                _alexRiveraCallImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFDDE6F9),
                  child: const Icon(Icons.person_rounded, color: _primary, size: 60),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Caller Name
          Text(
            controller.userName.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          // Live ticking duration
          Text(
            controller.callDurationString,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Header Overlay (Back Button & Video-Call Info) ────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: _primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        // Caller Details (Only shows on top right during active video call)
        if (controller.isVideo.value)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.userName.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.callDurationString,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ── Floating PIP (Picture in Picture) Inset Card ───────────────────────────
  Widget _buildFloatingInset() {
    final isVideo = controller.isVideo.value;
    return Container(
      width: 104,
      height: 144,
      decoration: BoxDecoration(
        color: _bgSlate800.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Window Content (User Selfie / Camera or User Circular Avatar)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isVideo
                  ? Image.network(
                      _userSelfieImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildAvatarPlaceholder(),
                    )
                  : Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _userSelfieImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildAvatarPlaceholder(),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          // Small microphone status icon at bottom right of the PIP window
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.isMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.grey.shade800,
      child: const Icon(Icons.person_rounded, color: Colors.white54, size: 30),
    );
  }

  // ── Bottom Control Panel Capsule ───────────────────────────────────────────
  Widget _buildControlsPanel() {
    final isVideo = controller.isVideo.value;
    final isMuted = controller.isMuted.value;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3547).withValues(alpha: 0.65), // Semi-transparent glass capsule
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ── Mic / Mute Toggle Button ───────────────────────────────────────
          _buildControlButton(
            onTap: () => controller.toggleMute(),
            // In video call, mute switches mic on/off. In audio call, it behaves similarly.
            // If active/unmuted: blue circle for mic, or grey circle if muted.
            icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            backgroundColor: isMuted ? Colors.white.withValues(alpha: 0.15) : _primary,
            iconColor: Colors.white,
          ),

          // ── Video Toggle Button ────────────────────────────────────────────
          _buildControlButton(
            onTap: () => controller.toggleVideo(),
            icon: isVideo ? Icons.videocam_rounded : Icons.videocam_off_rounded,
            backgroundColor: isVideo ? _primary : Colors.white.withValues(alpha: 0.15),
            iconColor: Colors.white,
          ),

          // ── Flip Camera Button ─────────────────────────────────────────────
          _buildControlButton(
            onTap: () => controller.toggleCamera(),
            icon: Icons.cached_rounded,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            iconColor: Colors.white,
          ),

          // ── End Call Button ────────────────────────────────────────────────
          _buildControlButton(
            onTap: () => Get.back(),
            icon: Icons.call_end_rounded,
            backgroundColor: _red,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }
}
